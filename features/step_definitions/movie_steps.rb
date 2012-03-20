# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    #Movie.find_by_title_and_rating(movie[:title], movie[:rating]).inspect
    if !Movie.find_by_title_and_rating(movie[:title], movie[:rating]) then
      Movie.create!(movie)
    end
  end
  assert (Movie.count >= movies_table.hashes.count), "Error while DB filling"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  assert page.body.match(/<td>#{e1}<\/td>(\s|\S)+<td>#{e2}<\/td>/), "Wrong movie order"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(/,( *)/).select{|i| i =~ /\w/}.each do |rating|
    if uncheck then
      step %{I uncheck "ratings[#{rating}]"}
    else
      step %{I check "ratings[#{rating}]"}
    end
  end
end

Then /I should see all movies/ do
  rows = page.all("table#movies tbody tr td[1]").map! {|t| t.text}
  assert ( rows.size == Movie.all.count )
end

Then /I should not see any movie/ do
   rows = page.all("table#movies tbody tr td[1]").map! {|t| t.text}
  assert rows.size == 0
end
