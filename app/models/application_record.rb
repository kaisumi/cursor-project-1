# frozen_string_literal: true

# Base class for all ActiveRecord models in the application.
# Provides common functionality and configuration for all models.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
