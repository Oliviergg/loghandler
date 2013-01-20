class Loghandler::LogDetail
  include MongoMapper::Document
  key :content, String
  timestamps!

end