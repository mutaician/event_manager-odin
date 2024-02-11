# Event Manager Project

This project, created as part of The Odin Project, helps manage event attendees and generate customized thank-you letters. It relies on the following libraries:

* `csv`: Reading attendee data from a CSV file.
* `google/apis/civicinfo_v2`: Fetching legislators information based on zip code.
* `erb`: Generating customized letters using templates.
* `time`: Parsing registration timestamps and analyzing data.

### Key functionalities

* **Reads attendee data:** Processes a CSV file (`event_attendees.csv`) containing attendee information (ID, name, zip code, phone number, registration date).
* **Fetches legislators:** Retrieves relevant legislators for each attendee based on their zip code using the Google Civic Information API.
* **Generates thank-you letters:** Creates personalized thank-you letters for each attendee using an ERB template (`form_letter.erb`) and fills in data like name and legislators.
* **Saves letters:** Saves thank-you letters as HTML files in the `output` directory.
* **Cleans phone numbers:** Cleans invalid characters and formats phone numbers consistently.
* **Analyzes registration data:** Tracks the number of registrations per hour and day of the week based on registration timestamps.

### How to run

1. Ensure you have the required libraries installed (`csv`, `google-api-client`, `erb`).
2. The API key in `legislators_by_zipcode` was part of the project.
3. Make sure the `event_attendees.csv` and `form_letter.erb` files are present in the project directory.
4. Run the Ruby script (e.g., `ruby event_manager.rb`).

### Output

* Individual thank-you letters saved as HTML files in the `output` directory.
* Information about the most popular registration hours and weekdays printed to the console.

