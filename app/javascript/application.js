// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

Turbo.StreamActions.scroll_to_bottom = function () {
  const target = this.targetElements[0];
  target.scrollIntoView({behavior: "smooth", block: "end"});
};

Turbo.StreamActions.scroll_to_top = function () {
  const target = this.targetElements[0];
  target.scrollIntoView({behavior: "smooth", block: "start"});
};
Turbo.start();
