import Editor from "easymde";

document.addEventListener("DOMContentLoaded", () => {
  for (const element of document.querySelectorAll(".markdown-editor")) {
    new Editor({
      element,
      spellChecker: false,
      minHeight: "100px"
    })
  }
});
