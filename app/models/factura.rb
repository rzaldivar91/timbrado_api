class Factura < ApplicationRecord
  belongs_to :cliente

  has_many :pagos, dependent: :restrict_with_error
  has_many :timbrados, dependent: :restrict_with_error

  validates :folio, :total, :estatus, presence: true
end
