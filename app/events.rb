# frozen_string_literal: true
require 'date'

class Events < Rack::App
  desc 'react to created event'
  post '/' do
    # include_player_ids: player_ids.exclude(sender_id)
    data = JSON.parse(payload, object_class: OpenStruct).createdNode

    Notifier.send_push(
      created_event_params(
        data.id,
        data.course,
        data.scoringType,
        Date.parse(data.startsAt).to_s,
        data.teamEvent
      )
    )
  end

  protected

  # rubocop:disable Metrics/MethodLength
  def created_event_params(id, course, scoring_type, starts_at, team_event)
    par = push_params
    par[:contents] = {
      en: "#{starts_at}. #{course.club}: #{course.name}. #{team_event ? 'Team' : 'Individual'}, #{scoring_type&.capitalize}",
      sv: "#{starts_at}. #{course.club}: #{course.name}. #{team_event ? 'Lag' : 'Individuell'}, #{scoring_type == 'points' ? 'Poäng' : 'Slag'}"
    }
    par[:headings] = {
      en: 'New round added',
      sv: 'Ny runda tillagd'
    }
    par[:subtitle] = {
      en: 'Check it out',
      sv: 'Titta till den nu vetja'
    }
    par[:collapse_id] = 'id1'

    par[:data] = { route: '/events', eventId: id }
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
      content_available: false,
      mutable_content: false,
      buttons: [
        { id: 'id1', text: 'Gå till runda', icon: 'ic_menu_share' }
      ],
      ios_badgeType: 'Increase',
      ios_badgeCount: 1,
      ios_sound: 'glf_swng.caf',
      collapse_id: '',
      android_group: 'Tisdagsgolfen',
      included_segments: 'All'
    }
  end
  # rubocop:enable Metrics/MethodLength
end
