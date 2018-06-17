class Driver < ActiveRecord::Base
  def self.filter param
    Driver.where(
      'lower(name) LIKE :filter or lower(identification) LIKE :filter
        or lower(carriage_plate) LIKE :filter',
      {filter: "#{param}%".downcase}
    )
  end
end
