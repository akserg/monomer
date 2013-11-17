// Copyright (c) 2013, akserg (Sergey Akopkokhyants)
// https://github.com/akserg/monomer
// All rights reserved.  Please see the LICENSE.md file.

library example_user;

/*
 * This is User info.
 */
class User {
  
  /**
   * User id.
   */
  int id;
  
  /**
   * User name.
   */
  String name;
  
  /**
   * User last name
   */
  String lastName;
  
  /**
   * User age.
   */
  int age;
  
  /**
   * User email.
   */
  String email;
  
  /**
   * User password.
   */
  String password;
  
  /**
   * User password again.
   */
  String passwordAgain;
  
  /**
   * Create an instance of User.
   */
  User(this.id, {this.name:'', this.lastName:'', this.age:0, this.email:'', this.password:''});
  
  /**
   * Convert User to JSON String
   */
  String toJson() {
    return "{id:$id, name:$name, lastName:$lastName, age:$age, email:$email, password:$password, passwordAgain:$passwordAgain}";
  }
  
  /**
   * Present User to string.
   */
  String toString() {
    return "id:$id, name:$name, lastName:$lastName, age:$age, email:$email, password:$password, passwordAgain:$passwordAgain";
  }
}
