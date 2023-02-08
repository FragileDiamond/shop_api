module ErrorSerializer
  def self.serialize(object)
    object.errors.messages.map do |field, errors|
      errors.map do |error_message|
        {
          code: :unprocessable_entity,
          status: "422",
          title: "Validation Error",
          detail: "#{field.capitalize} #{error_message}",
          source: {pointer: "/data/attributes/#{field}"},
          meta: { attribute: field, message: error_message, code: error_message.split.last }
        }
      end
    end.flatten
  end
end
