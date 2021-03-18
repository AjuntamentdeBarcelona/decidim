/* eslint-disable no-console */

$(() => {
  if (!console) {
    return;
  }

  const allMessages = window.Decidim.config.get("messages");
  if (!allMessages) {
    return;
  }
  const messages = allMessages.selfxssWarning;

  console.log(`%c${messages.title}`, "color:#f00;font-weight:bold;font-size:50px;");
  console.log(`%c${messages.description}`, "font-size:24px;");
});
