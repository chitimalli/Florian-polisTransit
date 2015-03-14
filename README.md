# arctouchtest
ArcTouchTest
#This is a ArcTouch test to get REST API calls working on the public transportation system

The REST APIs listed below require authentication, all the requests must include a HTTP Basic Authentication header. 

The app will consist of two screens: 
The List View and the Details View

- The List View, which shows the routes as a list. There will be a search box, 
where the user can type a name of a street and then tap on a button called "Search". 

The app should query this endpoint to get the results:

Some streets for testing: 
[Delminda Silveira, Mauro Ramos, Governador Irineu Bornhausen, Deputado Antônio Edu Vieira].

The results are displayed as a list of routes that contain the named street within it's track. 
The user may tap on a route listed to go to the next screen showing the route's details.

- The Details view shows the Route's name, the list of streets within the route and its 
timetable organised by type of the day -- weekday, saturday or sunday.