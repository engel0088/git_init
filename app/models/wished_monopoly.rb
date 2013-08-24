class WishedMonopoly < ActiveRecord::Base
  belongs_to :monopoly
  belongs_to :contractor

  before_save :create_monopoly
  after_destroy :destroy_monopoly

  attr_accessor :zip_code_id, :category_id

private

  def create_monopoly
    # TODO: This should be inside a transaction
    self.monopoly_id = Monopoly.create_once(:zip_code_id => self.zip_code_id, :category_id => self.category_id).id
        
  end

  def destroy_monopoly

  end

end
