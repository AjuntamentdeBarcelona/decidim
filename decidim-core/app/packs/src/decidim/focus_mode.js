$(() => {
  const $focusModeOn = $("[data-focus-on]");
  const $focusModeOff = $("[data-focus-off]");
  const $wrapper = $(".focus-mode__body");
  const $focusContent = $("[data-focus-body]");
  const $pageContent = $("#content");
  const $closer = $("[data-focus-close]");
  const $opener = $("[data-focus-open]");
  const $flashMessagesContainer = $(".focus-mode__flash-messages");

  const $background = $(".title-bar, [data-set='nav-holder'], .process-header");

  const $overlay = $(".omnipresent-banner, .cookie-warning");
  const $cookieButton = $(".cookie-bar__button");

  const FADEOUT_TIME = 200;

  const moveFlashMessages = () => {
    $(".flash.callout").appendTo($flashMessagesContainer);
  };

  const flashMessagesObserver = new MutationObserver((mutations) => {
    mutations.forEach((mutation) => {
      if (mutation.addedNodes !== null) {
        let $nodes = $(mutation.addedNodes);
        if ($nodes.filter(".flash.callout").length > 0) {
          moveFlashMessages();
        }
      }
    });
  });

  const watchFlashMessages = () => {
    // Pass in the target node, as well as the observer options
    flashMessagesObserver.observe($("#content")[0], { attributes: true, childList: true, characterData: true });
  };

  const unwatchFlashMessages = () => {
    flashMessagesObserver.disconnect();
  };

  const overlayHeight = () => {
    let height = 0;
    $overlay.outerHeight((index, value) => {
      if ($($overlay[index]).is(":visible")) {
        height += value;
      }
    });
    return height;
  };

  const moveToShowOverlay = () => {
    const top = $(document).scrollTop();
    const height = overlayHeight();

    if (top <= height) {
      $focusModeOn.css({ top: `${height}px` })
    } else {
      $focusModeOn.css({ top: "0px" })
    }
  }

  const moveOverlay = () => {
    if (!$overlay.length) {
      return;
    }

    if ($cookieButton.length) {
      $cookieButton.on("click", moveToShowOverlay);
    }

    moveToShowOverlay();
    window.addEventListener("scroll", moveToShowOverlay);
  }

  const focusModeOn = function(fadeTime) {
    if ($opener.length) {
      $opener.fadeOut(fadeTime);
    }

    $background.hide(fadeTime);
    $pageContent.animate({ "margin-top": `${$focusModeOn.outerHeight() + overlayHeight() - 50}px` }, fadeTime);

    moveOverlay();
    moveFlashMessages();

    $focusContent.fadeOut(fadeTime, () => {
      $focusContent.detach().prependTo($wrapper);
      $focusModeOn.fadeIn(fadeTime, () => {
        $focusContent.fadeIn(fadeTime, () => {});
      });
    });

    watchFlashMessages();
  }

  const focusModeOff = function(fadeTime) {
    $focusContent.fadeOut(fadeTime);
    $background.show(fadeTime);
    $pageContent.animate({ "margin-top": "0px" }, fadeTime);

    $focusModeOn.fadeOut(fadeTime, () => {
      $focusContent.detach().prependTo($focusModeOff);
      $focusModeOff.fadeIn(fadeTime, () => {
        $focusContent.fadeIn(fadeTime);
        if ($opener.length) {
          $opener.fadeIn(fadeTime);
        }
      });
    });

    unwatchFlashMessages();
  }

  const initializeFocusMode = () => {
    const focusModePresent = Boolean($focusModeOn.length);

    $closer.on("click", () => {
      focusModeOff(FADEOUT_TIME)
    });

    if ($opener.length) {
      $opener.on("click", () => {
        focusModeOn(FADEOUT_TIME)
      });
    }

    if (focusModePresent > 0 && window.matchMedia("(min-width: 800px)").matches) {
      focusModeOn(0);
    } else {
      focusModeOff(0);
    }
  }

  initializeFocusMode();

  $(window).resize(initializeFocusMode);
});
