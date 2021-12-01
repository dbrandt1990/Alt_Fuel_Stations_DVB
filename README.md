# Alt_Fuel_Stations_DVB
Rails portfolio project

## Description

Allow for users to create a profile to view alternative fueling staions in their zip.
Users will have access to the entire catalog of staions in the US and Canada.
Users can see which stations in their area have been updated or maybe being built.
Users can add personal notes that only they can view.
Users can see notes added by and ADMIN for data managment.

[🎥 Video walkthrough](https://youtu.be/nmwnN6R8BUc)

## Installation

* Fork/Clone repo
* Run
```
rails s 
```
## Help
If there are User created stations and you click check for updates on the users stations 
page, those stations will be removed.This happens beacuse the API is not integrating the
user created stations so when comparing local data to the API data it looks as if those 
stations don't exist anymore. If this app went live the intention is to integrate the
residential "stations" into the API after being approved by and admin.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## Blog
[Blog post on medium](https://dvbrandt90.medium.com/its-the-final-finale-finally-db9a2bc31e4f)

## Author
[Danny Brandt](https://www.linkedin.com/in/dbrandt1990/)

## License
[MIT](https://choosealicense.com/licenses/mit/)

