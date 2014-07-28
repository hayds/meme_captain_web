# encoding: UTF-8

require 'time'

require 'rails_helper'

describe GendThumbsController, type: :controller do

  describe "GET 'show'" do

    context 'when the id is found' do

      let(:gend_thumb) { mock_model(GendThumb) }

      it 'shows the thumbnail' do
        expect(GendThumb).to receive(:find).and_return(gend_thumb)

        get 'show', id: 1

        expect(response).to be_success
      end

      it 'has the right content type' do
        expect(gend_thumb).to receive(:content_type).and_return('content type')
        expect(GendThumb).to receive(:find).and_return(gend_thumb)

        get 'show', id: 1

        expect(response.content_type).to eq('content type')
      end

      it 'has the right content' do
        expect(gend_thumb).to receive(:image).and_return('image')
        expect(GendThumb).to receive(:find).and_return(gend_thumb)

        get 'show', id: 1

        expect(response.body).to eq('image')
      end

      it 'has the correct Cache-Control header' do
        expect(GendThumb).to receive(:find).and_return(gend_thumb)

        get :show, id: 1

        cache_control = response.headers['Cache-Control']
        expect(cache_control).to eq 'max-age=604800, public'
      end

      it 'has the correct Expires header' do
        expect(GendThumb).to receive(:find).and_return(gend_thumb)

        Timecop.freeze(Time.parse('feb 8 2010 21:55:00 UTC')) do
          get :show, id: 1
        end

        expires_header = response.headers['Expires']
        expect(expires_header).to eq 'Mon, 15 Feb 2010 21:55:00 GMT'
      end

    end

    context 'when the id is not found' do

      it 'raises record not found' do
        expect { get 'show', id: 1 }.to raise_error(
                                            ActiveRecord::RecordNotFound)
      end

    end

  end

end
