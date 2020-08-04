module Npi
  class Provider
    def self.create(npi_number)
      npi_registry = Npi::NpiRegistry.new

      response = npi_registry.provider(npi_number)

      return response if response['Errors'].present?

      attributes = response['results'].first

      new_attributes = Npi::ProviderParamsFormatter.call(attributes)

      provider = ::Provider.new(new_attributes)

      if provider.save
        { status: 200, provider: provider }
      else
        { status: 422, message: provider.errors.full_messages.to_sentence }
      end
    end
  end
end
