class User
  include JobNotifier::Identifier

  attr_accessor :id, :email

  indentify_by :id, :email
end
