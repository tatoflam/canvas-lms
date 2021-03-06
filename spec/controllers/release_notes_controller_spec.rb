# frozen_string_literal: true

#
# Copyright (C) 2021 - present Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.
#

require 'spec_helper'
require 'webmock/rspec'

describe ReleaseNotesController do
  around(:each) do |example|
    override_dynamic_settings(private: { canvas: { 'release_notes.yml': {
      ddb_endpoint: ENV.fetch('DDB_ENDPOINT', 'http://dynamodb:8000/'),
      ddb_table_name: 'canvas_test_release_notes'
    }.to_json }}) do
      ReleaseNotes::DevUtils.initialize_ddb_for_development!(recreate: true)
      example.run
    end
  end

  let(:show_at) { Time.now.utc.change(usec: 0) - 1.hour }

  let(:note) do
    note = ReleaseNote.new
    note.target_roles = ['student', 'ta']
    note.set_show_at('test', show_at)
    note.published = false
    note['en'] = {
      title: 'A boring title',
      description: 'A boring description',
      url: 'https://example.com/note0'
    }
    note.save
    note
  end

  before do
    user_session(account_admin_user(account: Account.site_admin))
  end

  describe 'index' do
    it 'should return the object without langs by default' do
      the_note = note
      get 'index'
      res = JSON.parse(response.body)
      expect(res.first['id']).to eq(the_note.id)
      expect(res.first['langs']).to be_nil
    end
    it 'should return the object with langs with includes[]=langs' do
      the_note = note
      get 'index', params: { includes: ['langs'] }
      res = JSON.parse(response.body)
      expect(res.first['id']).to eq(the_note.id)
      expect(res.first.dig('langs', 'en')&.with_indifferent_access).to eq(note['en'].with_indifferent_access)
    end
  end

  describe 'create' do
    it 'should create a note with the expected values' do
      post 'create', params: {
        target_roles: ['user'],
        show_ats: { 'test' => show_at },
        published: true,
        langs: {
          en: {
            title: 'A great title',
            description: 'A great description',
            url: 'https://example.com/note1'
          }
        }
      }, as: :json
      res = JSON.parse(response.body)
      the_note = ReleaseNote.find(res['id'])
      expect(the_note.target_roles).to eq(['user'])
      expect(the_note.show_ats['test']).to eq(show_at)
      expect(the_note.published).to be(true)
      expect(the_note['en'][:title]).to eq('A great title')
      expect(the_note['en'][:description]).to eq('A great description')
      expect(the_note['en'][:url]).to eq('https://example.com/note1')
    end
  end

  describe 'update' do
    it 'should update an existing note in the expected way' do
      the_note = ReleaseNote.find(note.id)
      expect(the_note.target_roles).to_not be_nil
      put 'update', params: {
        id: the_note.id,
        target_roles: ['user'],
        show_ats: { 'test' => show_at + 35.minutes },
        published: true,
        langs: {
          en: {
            title: 'A great title',
            description: 'A great description',
            url: 'https://example.com/note1'
          }
        }
      }, as: :json
      the_note = ReleaseNote.find(note.id)
      expect(the_note.target_roles).to eq(['user'])
      expect(the_note.show_ats['test']).to eq(show_at + 35.minutes)
      expect(the_note.published).to be(true)
      expect(the_note['en'][:title]).to eq('A great title')
      expect(the_note['en'][:description]).to eq('A great description')
      expect(the_note['en'][:url]).to eq('https://example.com/note1')
    end

    it 'works when not updating anything' do
      the_note = ReleaseNote.find(note.id)
      expect(the_note.target_roles).to_not be_nil
      put 'update', params: { id: the_note.id }
      expect(response.status).to eq(200)
      res = JSON.parse(response.body)
      expect(res['id']).to eq(the_note.id)
    end

    it 'should return 404 for non-existant notes' do
      put 'update', params: { id: SecureRandom.uuid, target_roles: ['user'] }
      expect(response.status).to eq(404)
    end
  end

  describe 'destroy' do
    it 'should remove an existing note' do
      the_note = ReleaseNote.find(note.id)
      expect(the_note).to_not be_nil
      delete 'destroy', params: { id: the_note.id }
      expect { ReleaseNote.find(note.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'should return 404 for non-existant notes' do
      delete 'destroy', params: { id: SecureRandom.uuid }
      expect(response.status).to eq(404)
    end
  end

  describe 'publish' do
    it 'should publish an unpublished note' do
      the_note = ReleaseNote.find(note.id)
      expect(the_note.published).to eq(false)
      put 'publish', params: { id: the_note.id }
      the_note = ReleaseNote.find(note.id)
      expect(the_note.published).to eq(true)
    end
  end

  describe 'unpublish' do
    it 'should publish an unpublished note' do
      the_note = ReleaseNote.find(note.id)
      the_note.published = true
      the_note.save

      expect(the_note.published).to eq(true)
      delete 'unpublish', params: { id: the_note.id }
      the_note = ReleaseNote.find(note.id)
      expect(the_note.published).to eq(false)
    end
  end
end
