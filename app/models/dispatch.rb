class Dispatch < ActiveRecord::Base
  belongs_to :import

  def self.filter filter
    case filter[:type]
    when 'code'
      self.filter_by_code(filter[:text])
    when 'contact'
      self.filter_by_contact(filter[:text])
    when 'date'
      self.filter_by_date(filter[:date])
    else
      self.filter_by_city(filter[:text])
    end
  end

  def self.filter_by_code param
    Dispatch.where('lower(code) like ?', "#{param}%".downcase)
  end

  def self.filter_by_contact param
    Dispatch.where('lower(contact) like ?', "#{param}%".downcase)
  end

  def self.filter_by_date param
    Dispatch.where('date is ?', param)
  end

  def self.filter_by_city param
    Dispatch.where('lower(city) like ?', "#{param}%".downcase)
  end

  def self.by_import import_id
    Dispatch.where('import_id = ?', import_id)
  end
end
