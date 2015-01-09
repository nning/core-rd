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
    before do
      post_body :create, '</test1>;if="test",</test2>', ep: 'foo'
      @id = response.headers['Location'].split('/').last.to_i
    end

    context 'valid' do
      let(:rr) { ResourceRegistration.find(@id) }

      context 'empty' do
        before { post :update, id: @id }

        it { expect(response.status).to eq(204) }
      end

      context 'lt' do
        let(:lt) { rand(60..86399) }

        before { post :update, id: @id, lt: lt }

        it { expect(response.status).to eq(204) }
        it { expect(rr.lt).to eq(lt) }
      end

      context 'con' do
        let(:con)  { "coap://0.0.0.0:#{port}" }
        let(:port) { rand(49152..65535) }

        before { post :update, id: @id, con: con }

        it { expect(response.status).to eq(204) }
        it { expect(rr.con).to eq(con) }
      end
    end
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
