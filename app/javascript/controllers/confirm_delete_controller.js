import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  handleConfirm(event) {
    if (!confirm("Are you sure you want to delete this payroll period?")) {
      event.preventDefault();
    }
  }
}
