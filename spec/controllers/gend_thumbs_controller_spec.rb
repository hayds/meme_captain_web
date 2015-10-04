# encoding: UTF-8

require 'time'

require 'rails_helper'

describe GendThumbsController, type: :controller do
  describe "GET 'show'" do
    context 'when the id is found' do
      it 'shows the thumbnail' do
        gend_thumb = FactoryGirl.create(:gend_thumb)

        get :show, id: gend_thumb.id

        expect(response).to be_success
      end

      it 'has the right content type' do
        gend_thumb = FactoryGirl.create(:gend_thumb)

        get :show, id: gend_thumb.id

        expect(response.content_type).to eq(gend_thumb.content_type)
      end

      it 'has the right Content-Length header' do
        gend_thumb = FactoryGirl.create(:gend_thumb)

        get('show', id: gend_thumb.id)

        expect(response.headers['Content-Length']).to eq(279)
      end

      it 'has the right content' do
        gend_thumb = FactoryGirl.create(:gend_thumb)

        get :show, id: gend_thumb.id

        expect(response.body).to eq(gend_thumb.image)
      end

      it 'has the correct Cache-Control header' do
        gend_thumb = FactoryGirl.create(:gend_thumb)

        get :show, id: gend_thumb.id

        cache_control = response.headers['Cache-Control']
        expect(cache_control).to eq 'max-age=604800, public'
      end

      it 'has the correct Expires header' do
        gend_thumb = FactoryGirl.create(:gend_thumb)

        Timecop.freeze(Time.parse('feb 8 2010 21:55:00 UTC')) do
          get :show, id: gend_thumb.id
        end

        expires_header = response.headers['Expires']
        expect(expires_header).to eq 'Mon, 15 Feb 2010 21:55:00 GMT'
      end
    end

    context 'when the id is not found' do
      it 'raises record not found' do
        expect { get :show, id: 1 }.to raise_error(
          ActiveRecord::RecordNotFound)
      end
    end
  end
end
