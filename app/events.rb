# frozen_string_literal: true
require 'date'

class Events < Rack::App
  desc 'react to created event'
  post '/' do
    # include_player_ids: player_ids.exclude(sender_id)
    data = JSON.parse(payload, object_class: OpenStruct).createdNode

    Notifier.send_push(
      created_event_params(
        data.course,
        data.scoringType,
        Date.parse(data.startsAt).to_s,
        data.teamEvent
      )
    )
  end

  protected

  # rubocop:disable Metrics/MethodLength
  def created_event_params(course, scoring_type, starts_at, team_event)
    par = push_params
    par[:contents] = {
      en: "#{starts_at}. #{course}. #{team_event ? 'Team' : 'Individual'}, #{scoring_type&.capitalize}",
      sv: "#{starts_at}. #{course}. #{team_event ? 'Lag' : 'Individuell'}, #{scoring_type == 'points' ? 'Poäng' : 'Slag'}"
    }
    par[:headings] = {
      en: 'New round added',
      sv: 'Ny runda tillagd'
    }
    par[:subtitle] = {
      en: 'Check it out',
      sv: 'Titta till den nu vetja'
    }
    par[:collapse_id] = 'tisdagsgolfen_event_created'

    par
  end

  def push_params
    {
      app_id: '92ef9314-1d1d-4c51-99c7-f265769161da',
      contents: {
        en: '',
        sv: ''
      },
      headings: {
        en: '',
        sv: ''
      },
      subtitle: {
        en: '',
        sv: ''
      },
      content_available: true,
      mutable_content: true,
      buttons: [
        { id: 'id1', text: 'Titta titta', icon: 'ic_menu_share' }
      ],
      ios_badgeType: 'Increase',
      ios_badgeCount: 1,
      collapse_id: '',
      android_group: 'Tisdagsgolfen',
      included_segments: 'All'
    }
  end
  # rubocop:enable Metrics/MethodLength
end
