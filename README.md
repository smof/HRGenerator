HRGenerator
-----------

Generates a CSV file that resembles an HR system extract for a made up organisation.  Useful for system testing.

Can consume a given list of names via an input file, or have names generated via a dictionary.

Output file contains the following fields:

<b>employeeid<b/> - auto-generated based on the following format: fl##### where f=first char of firstname, l=first char of lastname
<br>
<br>
<b>start_date<b/> - randomized from specified range
<br>
<br>
<b>firstname</b> - as is
<br>
<br>
<b>lastname<b/> - as is
<br>
<br>
<b>fullname<b/> - firstname + lastname
<br>
<br>
<b>email<b/> - concatentation of firstname.lastname@COMPANY_NAME.com
<br>
<br>
<b>title<b/> = randomized per department
<br>
<br>dept<b/> = randomized
<br>
<br>
A manager field is also populated, with a manager specified for each dept, linking back to each employee in those departments
<br>
<br>
I use it in combination with <a href="http://www.github.com/smof/NameGenerator"><b>NameGenerator<b/><a/> for seeding.
<br>
<br>
<b>Use as-is, no warranty.  Feel free to fork, modify, distribution, as long as attribution is in place.</b>


