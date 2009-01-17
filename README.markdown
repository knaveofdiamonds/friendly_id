FriendlyId
==========

Modifies an ActiveRecord model such that an attribute other than `id`
can be transparently used as a uri parameter.

Example
-------
<pre>
class User < ActiveRecord::Base
  friendly_id :username
end

User.find("rolandswingler") # => a User, (assuming that User exists)
User.find(1) # => still works as normal - you can still find by id
</pre>

The urls generated for `map.resources :user` would be: `/users/rolandswingler` 
rather than `/users/1`

The attribute that you use as a `friendly_id` must exist and be unique - 
`friendly_id` generates the ActiveRecord validations for this.

TODO / LIMITATIONS
------------------

* You can't search by multiple friendly_ids:
    `User.find("rolandswingler","fredbloggs") # won't work`
* Your `friendly_id`s can't be purely numeric - they'll assumed to be
  standard ids.

Copyright (c) 2009 Roland Swingler, released under the MIT license
