- in anouncement banner 
```
<style>
/* Editor: auto direction based on first strong character */
textarea,
.wiki-edit-content,
#description,
#comment,
.cke_editable,
.ProseMirror {
  direction: auto !important;
  unicode-bidi: plaintext !important;
}

/* Rendered description/comment: better mixed Persian-English handling */
#description-val,
.comment-body,
.action-body,
.user-content-block,
.ak-renderer-document,
.ak-renderer-document p,
#description-val p,
.comment-body p,
.action-body p,
.user-content-block p {
  unicode-bidi: plaintext !important;
}

/* If Jira/plugin marks content as Persian/Arabic, make it RTL */
[lang="fa"],
[lang="fa-IR"],
[lang="ar"],
[lang="ar-SA"],
[dir="rtl"] {
  direction: rtl !important;
  text-align: right !important;
  unicode-bidi: plaintext !important;
}
</style>
```
