/*
* requiring mongoose module.
* */
var mongoose = require ('mongoose');

// Defining ENUMs for the gender field which will use for validation.
var genders = 'MALE FEMALE'.split(' ')

// Connecting with mongodb(validation db).
mongoose.connect('mongodb://localhost/validation');

/*
* Defining User Schema with name(as Required Field), age(with Minimum and Maximum values),
* gender (which is ENUM, so it can be MALE or FEMALE only) and last one is email (which 
* will match the provided regex.)
* */
var UserSchema = mongoose.Schema({
    name: {type: String, required: true}, // 1. Required validation
    age: {type: Number, min: 16, max: 60}, // 2. Minimum and Maximum value validation
    gender: {type: String, enum: genders}, // 3. ENUM validation
    email: {type: String, match: /\S+@\S+\.\S+/} // 4. Match validation via regex
});

var User = mongoose.model('User', UserSchema);

/*
* When we call save function on the model, then first it calls validate function to validate 
* the values. Validate method takes callback as argument, if any error occurs at the time
* of validating values then validate function calls callback with errors otherwise calls
* with null.
* */
new User({age: 25}).validate(function (error) {
    console.log("ERROR: ", error); // Error for Name Field because its marked as Required.
});
new User({name: "Amit Thakkar", age:15}).validate(function (error) {
    console.log("ERROR: ", error); // Error for Age Field, age is less than Minimum value.
});
new User({name: "Amit Thakkar", age:61}).validate(function (error) {
    console.log("ERROR: ", error); // Error for Age Field, age is more than Maximum value.
});
new User({name: "Amit Thakkar", age:25, gender:"male"}).validate(function (error) {
    console.log("ERROR: ", error); // Error for Gender Field, male does not match with ENUM.
});
new User({name: "Amit Thakkar", age:25, gender:"MALE", email:"amit.kumar@intelligrape"}).validate(function (error) {
    console.log("ERROR: ", error); // Error for Invalid Email id.
});
new User({name: "Amit Thakkar", age:25, gender:"MALE", email:"amit.kumar@intelligrape.com"}).validate(function (error) {
    console.log("ERROR: ", error); // Error will be undefined
});