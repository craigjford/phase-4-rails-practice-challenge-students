class Student < ApplicationRecord

  validates :name, presence: true
  validates :age, numericality: { only_integer: :true, greater_than_or_equal_to: 18 }

  belongs_to :instructor, dependent: :destroy

end
