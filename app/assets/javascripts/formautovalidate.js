//*** This code is copyright 2002-2004 by Gavin Kistner, gavin@refinery.com
//*** It is covered under the license viewable at http://phrogz.net/JS/_ReuseLicense.txt
//*** Reuse or modification is free provided you abide by the terms of that license.
//*** (Including the first two lines above in your source code satisfies the conditions.)

/************************************************************
Form Auto Validation Library
v 1.1    20020721 -- added email, date, minLen, maxlength
v 1.2    20020723 -- tersified as library, NS6 compat, bug fixin, date ranges
v 1.2.1  20020730 -- non-required empty dates no longer incorrectly fail with bad format
v 1.2.2  20020808 -- extra \ added to email regexp to really require period
v 1.3    20030122 -- radio buttons now support required="true"
v 1.3.5  20030201 -- added generic form-level requiredmessage
v 1.3.6  20030228 -- integer types can now be negative
v 1.4    20030506 -- showallerrors added
v 1.4.5  20030529 -- skips disabled elements
v 1.4.6  20030612 -- minor tweak on event attaching to work with Safari
v 1.4.7  20030728 -- fix to skip 'elements' without .value (fieldset)
v 1.4.8  20030731 -- minlength only enforced on non-required elements when a value is supplied
v 1.5    20030801 -- regexp are now insensitive by default; added 'mustmatchcasesensitive="true"' option
v 1.6    20031126 -- minchecked and maxchecked added
v 1.8    20040222 -- minselected/maxselected/minchosen/maxchosen/mustnotmatch added;
                     regexp no longer wrapped in ^...$ automatically;
                     'failedvalidation' now added/removed from <label>s that go with elements.
v 1.8.1  20040401 -- mustnotmatch actually works now (thanks, reflous)
*************************************************************/

function AVF_Validate(f){
	var els = f.elements;
	var formReqMessage=f.getAttribute('requiredmessage');
	var showAllErrors = f.getAttribute("showallerrors") && (f.getAttribute("showallerrors")+"").toLowerCase()=="true";
	var allErrors={ firstEl:null, errorMsg:'' };
	if (formReqMessage=="") formReqMessage=null;
	for (var i=0,len=els.length;i<len;i++){
		var el = els[i];
		if (el.disabled || IsHidden(el) || el.value==null) continue;

		var reqd = el.getAttribute("required") && (el.getAttribute("required")+"").toLowerCase()=="true";
		var mustMatch = el.getAttribute("mustmatch") || null;
		var mustNotMatch = el.getAttribute("mustnotmatch") || null;
		var minVal = el.getAttribute("minvalue") || null;
		var maxVal = el.getAttribute("maxvalue") || null;
		var minLen = el.getAttribute("minlength") || null;
		var maxLen = el.getAttribute("maxlength") || null;
		var minChk = el.getAttribute("minchecked") || el.getAttribute("minchosen") || el.getAttribute("minselected") || null;
		var maxChk = el.getAttribute("maxchecked") || el.getAttribute("maxchosen") || el.getAttribute("maxselected") || null;
		var valAs = el.getAttribute("validateas") || null;

		var valLen = el.value.length;

		if (!reqd && mustMatch==null && minVal==null && maxVal==null && minLen==null && maxLen==null && valAs==null) continue;

		var niceName = el.getAttribute("nicename");
		if (!niceName) niceName=el.name;

		var valMsg = el.getAttribute("mustmatchmessage"); if (valMsg=="") valMsg=null;
		if (valAs!=null){
			valAs = valAs.toLowerCase();
			if (valAs=="email"){
				mustMatch='^[^@ ]+@[^@. ]+\\.[^@ ]+$';
				if (!valMsg) valMsg = niceName+" doesn't look like a valid email address. It must be of the format 'john@host.com'";
			} else if (valAs=="phone"){
				mustMatch='^\\D*\\d*\\D*(\\d{3})?\\D*\\d{3}\\D*\\d{4}\\D*$';
				if (!valMsg) valMsg = niceName+" must be a valid phone number in the format XXX-XXX-XXXX.";
			} else if (valAs=="zipcode"){
				mustMatch='^\\d{5}(?:-\\d{4})?$';
				if (!valMsg) valMsg = niceName+" doesn't look like a valid zip code. It should be 5 digits, optionally followed by a dash and four more, e.g. 19009 or 19009-2314";
			} else if (valAs=="integer"){
				mustMatch='^-?\\d+$';
				if (!valMsg) valMsg = niceName+" must be an integer.";
			} else if (valAs=="float"){
				mustMatch='^-?(?:\\d+|\\d*\.\\d+)$';
				if (!valMsg) valMsg = niceName+" must be a number, such as 1024 or 3.1415 (no commas are allowed).";
			}
		}
		
		var label = FindLabel(el);
		if (label) KillClass(label,'failedvalidation');

		var failMessage = el.getAttribute('requiredmessage')?el.getAttribute('requiredmessage'):formReqMessage?formReqMessage.replace(/%nicename%/gi,niceName):(niceName+' is a required field.');
		if (reqd && ((el.type!='radio' && (el.value==null || el.value=='')) || (el.type=='radio' && !AVF_RadioSelected(el)))){
			if (showAllErrors) AVF_AddError(allErrors,el,failMessage);
			else return AVF_Fail(el,failMessage);
		}
		if (mustMatch && el.value!=''){
			mustMatch = new RegExp(mustMatch,(el.getAttribute('mustmatchcasesensitive')=='true'?'':'i'));
			if (!mustMatch.test(el.value)){
				failMessage = valMsg?valMsg:(niceName+' is not in a valid format.');
				if (showAllErrors) AVF_AddError(allErrors,el,failMessage);
				else return AVF_Fail(el,failMessage);
			}
		}
		if (mustNotMatch && el.value!=''){
			mustNotMatch=new RegExp(mustNotMatch,(el.getAttribute('mustmatchcasesensitive')=='true'?'':'i'));
			if (mustNotMatch.test(el.value)){
				failMessage = valMsg?valMsg:(niceName+' is not in a valid format.');
				if (showAllErrors) AVF_AddError(allErrors,el,failMessage);
				else return AVF_Fail(el,failMessage);
			}
		}

		if (minVal!=null && valLen>0 && el.value*1<minVal*1){
			failMessage = niceName+' may not be less than '+minVal+'.';
			if (showAllErrors) AVF_AddError(allErrors,el,failMessage);
			else return AVF_Fail(el,failMessage);
		}
		if (maxVal!=null && valLen>0 && el.value*1>maxVal*1){
			failMessage = niceName+' may not be greater than '+maxVal+'.';
			if (showAllErrors) AVF_AddError(allErrors,el,failMessage);
			else return AVF_Fail(el,failMessage);
		}
		if (minLen!=null && valLen<minLen*1 && (reqd || valLen>0)){
			failMessage = niceName+' must have at least '+minLen+' characters.';
			if (showAllErrors) AVF_AddError(allErrors,el,failMessage);
			else return AVF_Fail(el,failMessage);
		}
		if (maxLen!=null && valLen>maxLen*1){
			failMessage = niceName+' may not be more than '+maxLen+' characters (it is currently '+valLen+' characters).';
			if (showAllErrors) AVF_AddError(allErrors,el,failMessage);
			else return AVF_Fail(el,failMessage);
		}
		if (valAs=='date' && valLen>0){
			var curVal = new Date(el.value);
			if (isNaN(curVal)){
				failMessage = niceName+' must be a valid date (e.g. 12/31/2001)';
				if (showAllErrors) AVF_AddError(allErrors,el,failMessage);
				else return AVF_Fail(el,failMessage);
			}
			if (minVal!=null && new Date(minVal)>curVal){
				failMessage = niceName+' must be no earlier than '+FormatDateTime(new Date(minVal),'#M#/#D#/#YYYY#')+'.';
				if (showAllErrors) AVF_AddError(allErrors,el,failMessage);
				else return AVF_Fail(el,failMessage);
			}
			if (maxVal!=null && new Date(maxVal)<curVal){
				failMessage = niceName+' must be no later than '+FormatDateTime(new Date(maxVal),'#M#/#D#/#YYYY#')+'.';
				if (showAllErrors) AVF_AddError(allErrors,el,failMessage);
				else return AVF_Fail(el,failMessage);
			}
		}
		if (minChk!=null || maxChk!=null){
			var checked = el.type=='checkbox' ? AVF_CheckBoxCount(el) : el.options ? AVF_SelectCount(el) : null;
			if (checked<minChk){
				failMessage = 'Please choose at least '+minChk+' '+niceName;
				if (showAllErrors) AVF_AddError(allErrors,el,failMessage);
				else return AVF_Fail(el,failMessage);
			}
			if (checked>maxChk){
				failMessage = 'Please choose no more than '+maxChk+' '+niceName;
				if (showAllErrors) AVF_AddError(allErrors,el,failMessage);
				else return AVF_Fail(el,failMessage);
			}
		}
	}

	if (showAllErrors && allErrors.firstEl) return AVF_Fail(allErrors.firstEl,allErrors.errorMsg);

// INSERT AJAX CALLS HERE AND SWITCH RETURN TRUE TO RETURN FALSE;

	return true;
}

function AVF_RadioSelected(el){
	var f = el.form;
	var els = f.elements[el.name];
	for (var i=0,len=els.length;i<len;i++) if (els[i].checked){
		return true;
	}
	return false;
}

function AVF_CheckBoxCount(el){
	var f = el.form;
	var els = f.elements[el.name];
	for (var i=0,ct=0,len=els.length;i<len;i++) if (els[i].checked) ct++;
	return ct;
}

function AVF_SelectCount(el){
	for (var i=0,chk=0,len=el.options.length;i<len;i++) if (el.options[i].selected) chk++;
	return chk;
}

function AVF_AddError(allErrors,el,msg){
	if (el && !allErrors.firstEl) allErrors.firstEl=el;
	allErrors.errorMsg += (allErrors.errorMsg?'\n\n':'')+msg;
	var label = FindLabel(el);
	if (label) AddClass(label,'failedvalidation');
}

function AVF_Fail(el,msg){
	if (el){
		try{ el.focus(); } catch(e){};
		try{ el.select(); } catch(e){};
		var label = FindLabel(el);
		if (label) AddClass(label,'failedvalidation');
	}
	alert(msg);
	return false;
}

function AVF_Init(){
	for (var i=0,len=document.forms.length;i<len;i++){
		var f = document.forms[i];
		if (!f.getAttribute('autovalidate') || f.getAttribute('autovalidate').toLowerCase()!='true') continue;
		var valFunc = function(event){ if (!AVF_Validate(f)) return PreventDefault(event) };
		AttachEvent(f,'submit',valFunc,true);
	}
}

AttachEvent(window,'load',AVF_Init,true);


/*********************************************************************************
Following are copied from generic_library.js and should be checked for currentness
*********************************************************************************/

function AttachEvent(obj,evt,fnc,useCapture){
	if (!useCapture) useCapture=false;
	if (obj.addEventListener){
		obj.addEventListener(evt,fnc,useCapture);
		return true;
	} else if (obj.attachEvent) return obj.attachEvent('on'+evt,fnc);
	else{
		MyAttachEvent(obj,evt,fnc);
		obj['on'+evt]=function(){ MyFireEvent(obj,evt) };
	}
} 
function MyAttachEvent(obj,evt,fnc){
	if (!obj.myEvents) obj.myEvents={};
	if (!obj.myEvents[evt]) obj.myEvents[evt]=[];
	var evts = obj.myEvents[evt];
	evts[evts.length]=fnc;
}
function MyFireEvent(obj,evt){
	if (!obj || !obj.myEvents || !obj.myEvents[evt]) return;
	var evts = obj.myEvents[evt];
	for (var i=0,len=evts.length;i<len;i++) evts[i]();
}

Date.prototype.customFormat = function(formatString){
	var YYYY,YY,MMMM,MMM,MM,M,DDDD,DDD,DD,D,hhh,hh,h,mm,m,ss,s,ampm,AMPM,dMod,th;
	var dateObject = this;
	YY = ((YYYY=dateObject.getFullYear())+'').substr(2,2);
	MM = (M=dateObject.getMonth()+1)<10?('0'+M):M;
	MMM = (MMMM=['January','February','March','April','May','June','July','August','September','October','November','December'][M-1]).substr(0,3);
	DD = (D=dateObject.getDate())<10?('0'+D):D;
	DDD = (DDDD=['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'][dateObject.getDay()]).substr(0,3);
	th=(D>=10&&D<=20)?'th':((dMod=D%10)==1)?'st':(dMod==2)?'nd':(dMod==3)?'rd':'th';
	formatString = formatString.replace('#YYYY#',YYYY).replace('#YY#',YY).replace('#MMMM#',MMMM).replace('#MMM#',MMM).replace('#MM#',MM).replace('#M#',M).replace('#DDDD#',DDDD).replace('#DDD#',DDD).replace('#DD#',DD).replace('#D#',D).replace('#th#',th);

	h=(hhh=dateObject.getHours());
	if (h==0) h=24;
	if (h>12) h-=12;
	hh = h<10?('0'+h):h;
	AMPM=(ampm=hhh<12?'am':'pm').toUpperCase();
	mm=(m=dateObject.getMinutes())<10?('0'+m):m;
	ss=(s=dateObject.getSeconds())<10?('0'+s):s;
	return formatString.replace('#hhh#',hhh).replace('#hh#',hh).replace('#h#',h).replace('#mm#',mm).replace('#m#',m).replace('#ss#',ss).replace('#s#',s).replace('#ampm#',ampm).replace('#AMPM#',AMPM);
}
function FormatDateTime(date,str){ return date?date.customFormat(str):'' }

function PreventDefault(evt){
	if (!evt && window.event) evt=window.event;
	if (evt.preventDefault) evt.preventDefault();
	else evt.returnValue=false;
	return false;
}

function IsHidden(el){
	while (el!=null){
		if ((el.style && (el.style.display=='none' || el.style.visibility=='hidden')) || (el.currentStyle && (el.currentStyle.display=='none' || el.currentStyle.visibility=='hidden')))	return true;
		el=el.parentNode;
	}
	return false;
}

function FindLabel(obj){
	if (obj.label) return obj.label;
	var labels = typeof(document.getElementsByTagName)=='function' ? document.getElementsByTagName('label') : [];
	for (var i=0,len=labels.length;i<len;i++) if (labels[i].htmlFor==obj.id) return (obj.label=labels[i]);
	return null;
}

function AddClass(obj,cName){ KillClass(obj,cName); return obj.className+=(obj.className.length>0?' ':'')+cName; }
function KillClass(obj,cName){ return obj.className=obj.className.replace(new RegExp('^'+cName+'\\b\\s*|\\s*\\b'+cName+'\\b','g'),''); }
function HasClass(obj,cName){ return (!obj || !obj.className)?false:(new RegExp('\\b'+cName+'\\b')).test(obj.className) }
