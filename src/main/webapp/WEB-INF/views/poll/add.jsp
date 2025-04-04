<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<h2>Create New Poll</h2>
<form action="/poll/add" method="post">
  <div class="mb-3">
    <label class="form-label">Question</label>
    <input type="text" name="question" class="form-control" required>
  </div>

  <h4>Options</h4>
  <div class="mb-3">
    <input type="text" name="options[0].text" class="form-control mb-2" placeholder="Option 1" required>
    <input type="text" name="options[1].text" class="form-control mb-2" placeholder="Option 2" required>
    <input type="text" name="options[2].text" class="form-control mb-2" placeholder="Option 3" required>
    <input type="text" name="options[3].text" class="form-control mb-2" placeholder="Option 4" required>
  </div>

  <button type="submit" class="btn btn-primary">Create Poll</button>
  <a href="/" class="btn btn-secondary">Cancel</a>
</form>