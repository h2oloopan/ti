auth = require '../../helpers/auth'
should = require 'should'
describe 'auth', ->
    describe 'encrypt', ->
        it 'should return the sha256 hashed string in lower case hex format', ->
            input = 'x358c*S&VWS(@'
            output = auth.encrypt input
            output.should.equal '737f07d4c1517439f380b159b39224cd84f669ca799809fc499de0f76a976568'
