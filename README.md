[![Build Status](https://drone.io/github.com/akserg/monomer/status.png)](https://drone.io/github.com/akserg/monomer/latest)

##What is a Monomer?
The world has changed and now the components are used everywhere. Monomer is no exception. It is based on a component model of development implemented in Polymer. Monomer is a set of loosely coupled components with each other. This allows using only the required components in the development and reduce the size of the final web application. Monomer contains no specific styles, which will allow developers to use their own styles without restrictions and conflicts between them. 

A developer can start with a simple page containing only one component and gradually create a large web application using components from other developers without restrictions and with minimal effort . Monomer uniqueness lies in its ability to handle and manipulate the data. The developer can start using components of form, data grid or tree without training and immediately see the result. Monomer is based on a component model is very similar to Adobe Flex and Microsoft Silverlight. If the developer is familiar with the above frameworks that can quickly start using Monomer.

###Component
The abstract class Component is the base class in the Monomer. It contains a set of methods and attributes relevant to each component. Class Component is used only as a mixin, in order not to restrict the inheritance in class hierarchy. To create a new component, you must choose a standard HTML element or another component and add a Component as a mixin. Each component has the attribute 'data', which is used as a universal data storage component used.

###Buttons
Monomer Buttons can be useful in different situations. Each button from Monomer is programmed to perform a specific action.
- The Button component is the base for the rest. It defines the basic properties and behaviour of all the inherited buttons.
- Component PostButton performs a POST request contents of attribute 'data' without validation.
- Component DeleteButton asks for confirmation before executing the POST request.
- Component UploadButton to upload one or more files to the server.

###Form
The form is one of the most used components to obtain information from the user. Form component in Monomer does the following:
- Performs validation of form fields;
- Prepares the data to be sent;
- Fetchs the data received and updates the fields as necessary;

Form component does not manage the layout of form items and does not change their styles.

###ListBase
ListBase is base class for all multi item components such as ComboBox, ListBox etc. It basically provides multi items management and provides item rendering mechanism for render children. Each child is associated with one item in items array. ListBase provides selection mechanism including property value selection.
ListBase does not provide any styles for children, it only provides logic for items manipulation
such as filter, sort, collection change notification and updates.

###CheckBoxGroup
CheckBoxGroup is inherited from ListBase component. By default it allows multiple selection and
automatically provides comma separated values as value property. CheckBox component is default item renderer for CheckBoxGroup.

###RadioBoxGroup
RadioBoxGroup component is inherited from ListBase. By default it allows single item selection and uses RadioButton component as default item renderer.

##Fork the Monomer
If you'd like to contribute back to the core, you can fork this repository and send a pull request to me, when it is ready.

If you are new to Git or GitHub, please read this [guide](https://help.github.com/) first.

##License

Copyright (c) 2013 Sergey Akopkokhyants Licensed under the Apache 2.0 License.
