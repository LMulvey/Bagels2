# EventPolicy: handling of conditional policies for events
class EventPolicy
  def initialize(event:, ticket:, params:)
    @event = event
    @ticket = ticket
    @params = params
  end

  def can_update_event?
    return false if @event.ticket.status == 'completed'
    true
  end

  def can_create_event?
    return false if measurement_issue
    return false if @ticket.status == 'completed'
    true
  end

  def stop_without_start?
    return false if @ticket.events.find_by(event_type: 'start').nil?
    true
  end

  private

  # Is the measurement required (delivery / pickup) and not present?
  def measurement_issue
    measurement_required? && measurement_not_present?
  end

  # CONDITIONAL: Is the event type "delivery" or "pickup"?
  def measurement_required?
    @event.event_type == 'delivery' || @event.event_type == 'pickup'
  end

  # CONDITIONAL: Are either of the measurement values missing?
  def measurement_not_present?
    @event.measurement.blank? || @event.measurement_type.blank?
  end
end
