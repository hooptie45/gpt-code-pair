# features/step_definitions/interactive_session_steps.rb

Given("I have started a new interactive session") do
  # Initialize a new interactive session, possibly creating a new object or setting up necessary state
  @session = InteractiveSession.new
end

When("I enter the command {string}") do |command|
  # Send the command to the session and capture the response
  @response = @session.execute_command(command)
end

Then("a new project called {string} should be created") do |project_name|
  # Verify that the project was created, possibly by checking the database or the session state
  project = Project.find_by(name: project_name)
  expect(project).not_to be_nil
end

When("I enter the code {string}") do |code|
  # Handle the code input, possibly by updating the code in the session or in a file
  @session.add_code(code)
end

And("I enter the command {string}") do |command|
  # This step is the same as the "When I enter the command" step, so you can call that step here
  step "I enter the command \"#{command}\""
end

Then("the changes should be committed with the message {string}") do |message|
  # Verify that the changes were committed, possibly by checking the Git repository or the session state
  commit = @session.last_commit
  expect(commit.message).to eq(message)
end
