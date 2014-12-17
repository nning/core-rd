require 'rails_helper'

describe RdController, type: :controller do
  context 'registration' do
    context 'parameters' do
      it 'mandatory' do
        expect { get :create }.to \
          raise_error(ActionController::ParameterMissing)
        expect { get :create, ep: '' }.to \
          raise_error(ActionController::ParameterMissing)
        expect { get :create, ep: 'foo' }.not_to raise_error
      end
    end

    context 'body' do
      # TODO Couldn't find out, how to set request body.
      pending
    end
  end
end
