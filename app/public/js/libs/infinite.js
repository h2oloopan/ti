(function(window, Ember, $, Waypoint){
  var InfiniteScroll = {
    PAGE:     1,  // default start page
    PER_PAGE: 25 // default per page
  };

  function Infinite(options) {
    this.options = $.extend({}, Infinite.defaults, options);
    this.container = this.options.element;
    if (this.options.container !== 'auto') {
      this.container = this.options.container;
    }
    this.$container = $(this.container);
    this.$more = $(this.options.more);

    if (this.$more.length) {
      this.setupHandler();
      this.waypoint = new Waypoint(this.options);
    }
  }

  /* Private */
  Infinite.prototype.setupHandler = function() {
    this.options.handler = $.proxy(function() {
      this.options.onBeforePageLoad();
      this.destroy();
      this.$container.addClass(this.options.loadingClass);

      $.get($(this.options.more).attr('href'), $.proxy(function(data) {
        var $data = $($.parseHTML(data));
        var $newMore = $data.find(this.options.more);

        var $items = $data.find(this.options.items);
        if (!$items.length) {
          $items = $data.filter(this.options.items);
        }

        this.$container.append($items);
        this.$container.removeClass(this.options.loadingClass);

        if (!$newMore.length) {
          $newMore = $data.filter(this.options.more);
        }
        if ($newMore.length) {
          this.$more.replaceWith($newMore);
          this.$more = $newMore;
          this.waypoint = new Waypoint(this.options);
        }
        else {
          this.$more.remove();
        }

        this.options.onAfterPageLoad();
      }, this));
    }, this);
  };

  /* Public */
  Infinite.prototype.destroy = function() {
    if (this.waypoint) {
      this.waypoint.destroy();
    }
  };

  Infinite.defaults = {
    container: 'auto',
    items: '.infinite-item',
    more: '.infinite-more-link',
    offset: 'bottom-in-view',
    loadingClass: 'infinite-loading',
    onBeforePageLoad: $.noop,
    onAfterPageLoad: $.noop
  };

  Waypoint.Infinite = Infinite;

  InfiniteScroll.ControllerMixin = Ember.Mixin.create({
    loadingMore: false,
    page: InfiniteScroll.PAGE,
    perPage: InfiniteScroll.PER_PAGE,

    actions: {
      getMore: function(){
        if (this.get('loadingMore')) return;

        this.set('loadingMore', true);
        this.get('target').send('getMore');
      },

      gotMore: function(items, nextPage){
        this.set('loadingMore', false);
        this.pushObjects(items);
        this.set('page', nextPage);
      }
    }
  });

  InfiniteScroll.RouteMixin = Ember.Mixin.create({
    actions: {
      getMore: function() {
        throw new Error("Must override Route action `getMore`.");
      },
      fetchPage: function() {
        throw new Error("Must override Route action `getMore`.");
      }
    }
  });

  InfiniteScroll.ViewMixin = Ember.Mixin.create({
    setupInfiniteScrollListener: function(){
      $('.inf-scroll-outer-container').on('scroll.infinite', Ember.run.bind(this, this.didScroll));
    },
    teardownInfiniteScrollListener: function(){
      $('.inf-scroll-outer-container').off('scroll.infinite');
    },
    didScroll: function(){
      if (this.isScrolledToRight() || this.isScrolledToBottom()) {
        this.get('controller').send('getMore');
      }
    },
    isScrolledToRight: function(){
      var distanceToViewportLeft = (
        $('.inf-scroll-inner-container').width() - $('.inf-scroll-outer-container').width());
      var viewPortLeft = $('.inf-scroll-outer-container').scrollLeft();

      if (viewPortLeft === 0) {
        // if we are at the left of the page, don't do
        // the infinite scroll thing
        return false;
      }

      return (viewPortLeft - distanceToViewportLeft);
    },
    isScrolledToBottom: function(){
      var distanceToViewportTop = (
        $('.inf-scroll-inner-container').height() - $('.inf-scroll-outer-container').height());
      var viewPortTop = $('.inf-scroll-outer-container').scrollTop();

      if (viewPortTop === 0) {
        // if we are at the top of the page, don't do
        // the infinite scroll thing
        return false;
      }

      return (viewPortTop >= distanceToViewportTop);
    }
  });

  window.InfiniteScroll = InfiniteScroll;
})(this, Ember, jQuery, Waypoint);