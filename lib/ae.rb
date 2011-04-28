# Copyright (c) 2008,2011 Thomas Sawyer
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# AE's namespace.
module AE

  # Set Assertion class. This is a convenience method
  # for framework adapters, used to set the exception class
  # that a framework uses to raise an assertion error.
  def self.assertion_error=(exception_class)
    verbose, $VERBOSE = $VERBOSE, nil
    Object.const_set(:Assertion, exception_class)
    $VERBOSE = verbose
  end

end

require 'ae/version'
require 'ae/assert'
require 'ae/expect'

