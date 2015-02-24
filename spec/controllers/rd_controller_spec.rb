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
          expect(response.status).to eq(4.00)
        end

        it 'invalid' do
          post_body :create, 'foo', ep: 'foo'
          expect(response.status).to eq(4.00)
        end
      end

      context 'no error' do
        before { post_body :create, '</test1>;if="test",</test2>', ep: 'foo' }

        it { expect(response.status).to eq(2.01) }
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

        it { expect(response.status).to eq(2.04) }
      end

      context 'lt' do
        let(:lt) { rand(60..86399) }

        before { post :update, id: @id, lt: lt }

        it { expect(response.status).to eq(2.04) }
        it { expect(rr.lt).to eq(lt) }
      end

      context 'con' do
        let(:con)  { "coap://0.0.0.0:#{port}" }
        let(:port) { rand(49152..65535) }

        before { post :update, id: @id, con: con }

        it { expect(response.status).to eq(2.04) }
        it { expect(rr.con).to eq(con) }
      end

      context 'body' do
        context 'valid change' do
          before { post_body :update, '</test1>;if="test1"', id: @id }

          it { expect(response.status).to eq(2.04) }
          it { expect(rr.typed_links.size).to eq(2) }

          it do
            link = rr.typed_links.where(uri: '/test1').first
            attr = link.target_attributes.where(type: 'if').first

            expect(attr.value).to eq('test1')
          end
        end

        context 'valid create' do
          before { post_body :update, '</test3>;if="test3"', id: @id }

          it { expect(response.status).to eq(2.04) }
          it { expect(rr.typed_links.size).to eq(3) }

          it do
            link = rr.typed_links.where(uri: '/test3').first
            attr = link.target_attributes.where(type: 'if').first

            expect(attr.value).to eq('test3')
          end
        end

        context 'invalid' do
          before { post_body :update, 'invalid', id: @id }

          it { expect(response.status).to eq(4.00) }
          it { expect(rr.typed_links.size).to eq(2) }

          it do
            link = rr.typed_links.where(uri: '/test1').first
            attr = link.target_attributes.where(type: 'if').first

            expect(attr.value).to eq('test')
          end
        end
      end
    end
  end

  describe 'DELETE #destroy (removal)' do
    it 'deleted' do
      post_body :create, '</test>', ep: 'foo'
      expect(response.status).to eq(2.01)

      r = ResourceRegistration.first

      delete :destroy, id: r.id
      expect(response.status).to eq(2.02)
    end

    it 'not found' do
      expect { delete :destroy, id: 1 }.to \
        raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
