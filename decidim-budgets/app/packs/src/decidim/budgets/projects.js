$(() => {
  const $projects = $("#projects, #project");
  const $budgetSummaryTotal = $(".budget-summary__total");
  const $budgetExceedModal = $("#budget-excess");
  const $budgetSummary = $(".budget-summary__progressbox");
  const totalAllocation = parseInt($budgetSummaryTotal.attr("data-total-allocation"), 10);
  const $voteButton = $(".budget-vote-button");

  const cancelEvent = (event) => {
    $(event.currentTarget).removeClass("loading-spinner");
    event.stopPropagation();
    event.preventDefault();
  };

  const allowExitFrom = ($el) => {
    if ($el.parents("#loginModal").length > 0) {
      return true;
    } else if ($el.parents("#authorizationModal").length > 0) {
      return true;
    }

    return false;
  }

  $voteButton.on("click", "span", (event) => {
    $(".budget-list__action").click();
  });

  $projects.on("click", ".budget-list__action", (event) => {
    const currentAllocation = parseInt($budgetSummary.attr("data-current-allocation"), 10);
    const $currentTarget = $(event.currentTarget);
    const projectAllocation = parseInt($currentTarget.attr("data-allocation"), 10);

    if (!$currentTarget.attr("data-open")) {
      $currentTarget.addClass("loading-spinner");
    }

    if ($currentTarget.attr("disabled")) {
      cancelEvent(event);
    } else if (($currentTarget.attr("data-add") === "true") && ((currentAllocation + projectAllocation) > totalAllocation)) {
      $budgetExceedModal.foundation("toggle");
      cancelEvent(event);
    }
  });

  if ($("#order-progress [data-toggle=budget-confirm]").length > 0) {
    const safeUrl = $(".budget-summary").attr("data-safe-url").split("?")[0];
    $(document).on("click", "a", (event) => {
      if (allowExitFrom($(event.currentTarget))) {
        window.exitUrl = null;
      } else {
        window.exitUrl = event.currentTarget.href;
      }
    });
    $(document).on("submit", "form", (event) => {
      if (allowExitFrom($(event.currentTarget))) {
        window.exitUrl = null;
      } else {
        window.exitUrl = event.currentTarget.action;
      }
    });

    window.addEventListener("beforeunload", (event) => {
      const currentAllocation = parseInt($budgetSummary.attr("data-current-allocation"), 10);
      const exitUrl = window.exitUrl;
      window.exitUrl = null;

      if (currentAllocation === 0 || (exitUrl && exitUrl.startsWith(safeUrl))) {
        return;
      }

      event.returnValue = true;
    });
  }
});
