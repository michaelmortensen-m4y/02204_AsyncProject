
# This file contains an example of how to do state machines
# in Python.
# 
# TODO: We should make models of our STGS using these kind of classes
# https://github.com/pytransitions/transitions
# 
# 
from transitions import Machine


class Test(object):
    # This function will be called for the move transition since we added it in conditions
    def is_one(self, value): 
        if value > 0: 
            return True 
        else:
            return False

test_model = Test()




states=['start', 'end']

# And some transitions between states. We're lazy, so we'll leave out
# the inverse phase transitions (freezing, condensation, etc.).



machine = Machine(model=test_model, states=states , initial='start')

machine.add_transition('move', source='start', dest='end', conditions='is_one')
machine.add_transition('back', source='end', dest='start')


print(test_model.state)

test_model.move(value=1)

print(test_model.state)
