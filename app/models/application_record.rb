# frozen_string_literal: true

# Base class for ActiveRecord
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
