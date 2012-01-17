ActionController::Responder.class_eval do
  alias :to_tablet :to_html
end