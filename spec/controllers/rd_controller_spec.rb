require 'rails_helper'

describe RdController do
  describe 'POST #create (registration)' do
    context 'mandatory parameters' do
      it 'ep missing' do
        expect { post :create }.to \
          raise_error(ActionController::ParameterMissing)
      end

      it 'ep empty' do
        expect { post :create, ep: '' }.to \
          raise_error(ActionController::ParameterMissing)
      end

      it 'ep set' do
        expect { post :create, ep: 'foo' }.not_to raise_error
      end
    end

    context 'body' do
      context 'error' do
        it 'empty' do
          post_body :create, '', ep: 'foo'
          expect(response.status).to eq(400)
        end

        it 'invalid' do
          post_body :create, 'foo', ep: 'foo'
          expect(response.status).to eq(400)
        end
      end

      context 'no error' do
        before { post_body :create, '</test1>;if="test",</test2>', ep: 'foo' }

        it { expect(response.status).to eq(201) }
        it { expect(response.headers['Location']).to eq('/rd/1') }

        it { expect(ResourceRegistration.count).to eq(1) }
        it { expect(TypedLink.count).to eq(2) }
        it { expect(TargetAttribute.count).to eq(1) }
      end
    end
  end

  describe 'POST #update (update)' do
    pending
  end

  describe 'DELETE #destroy (removal)' do
    it 'deleted' do
      post_body :create, '</test>', ep: 'foo'
      expect(response.status).to eq(201)

      r = ResourceRegistration.first

      delete :destroy, id: r.id
      expect(response.status).to eq(202)
    end

    it 'not found' do
      expect { delete :destroy, id: 1 }.to \
        raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
