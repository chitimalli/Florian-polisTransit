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


///////////////////////////////////////////////
		ArcTouct Test- Implementation Documentation
///////////////////////////////////////////////


>> RoutesHTTPSessionManager 
- BaseHTTPURL AppGluOnlineURLString = @"https://api.appglu.com/v1/queries/";
- This Class used AFNetworking to connect to the service to make REST based HTTP POST calls



>> RoutesHTTPClientDelegate
- This is the protocol, that has to be implemented bu the below UIView Classe on Response



>> TransitData <<
- This class is a Singleton Data manager that will manage the Data for the query 



>>> JSONModel Classes
    - RouteModel		[Implements RouteJSON model for response from "findRoutesByStopName"]
    - StopModel 		[Implements RouteJSON model for response from "findStopsByRouteId"]
    - DeparturesModel 	[Implements RouteJSON model for response from "findDeparturesByRouteId"]



>> RoutesTableViewController <<
- This screen has the "Search" bar that can be used to search a street name
- There is a "Test" button to search some hardcoded street name
- There is Map button to navigate to the MapView



>> RouteDetailsView <<
- This View has 4 UI tables, all using same view as a TableView Delegate 
- The TOP table, displays the list of stops in the given route
- The bottom three tables, sort he times based on the WeekDay/SAT/SUN


>> TransitMapView
- Not implemented yet, have a placeholder map image
