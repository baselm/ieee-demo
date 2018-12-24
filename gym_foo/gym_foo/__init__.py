from gym.envs.registration import register

register(
    id='foo-v14',
    entry_point='gym_foo.envs:FooEnv',
)