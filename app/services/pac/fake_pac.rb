module Pac
  class FakePac
    def initialize(params, failed=false)
      @params = params
      @failed = failed
    end

    def timbrar
      if @failed
        {
          status: "fallida",
          external_id: @params[:external_id],
          error: "timeout"
        }
      else
        {
          status: "timbrada",
          external_id: @params[:external_id],
          uuid_fiscal: SecureRandom.uuid
        }
      end
    end
  end
end
