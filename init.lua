box.cfg{
    listen=3302
}

box.schema.user.grant('guest', 'read,write,execute', 'universe', nil, {if_not_exists=true})

if (box.space.links == nil) then
    links = box.schema.space.create('links')
    links:format({
        {name = 'source_link', type = 'string'},
        {name = 'icq_channel', type = 'string'},
        {name = 'user_id', type = 'string'},
        {name = 'source_last_id', type = 'string'},
        {name = 'source_id', type = 'string'},
        {name = 'source_type', type = 'string'},
        {name = 'link_id', type = 'string'}
    })
    links:create_index('primary', {
        parts = {
            {field = 1, type = 'string'},
            {field = 2, type = 'string'},
            {field = 3, type = 'string' }
        }}
    )
    links:create_index('secondary', {type = 'tree', unique = false, parts = { {field = 3, type = 'string'} } })
    links:create_index('tertiary', {type = 'tree', unique = false, parts = { {field = 6, type = 'string'} } })
end

if (box.space.links_old == nil) then
    -- create user space
    -- sequence
    box.schema.sequence.create('user', {if_not_exists=true})
    -- space
    box.schema.create_space('user', {
        if_not_exists = true,
        format={
            {name='id', type='unsigned'},
            {name='external_id', type='string'},
            {name='type_id', type='unsigned'}
        }
    })
    box.space.user:create_index('id', {
        type = 'tree',
        parts = {1, 'unsigned'},
        sequence='user',
        if_not_exists = true,
        unique=true
    })
    box.space.user:create_index('external_id_type_id', {
        type = 'tree',
        parts = {{2, 'string'}, {3, 'unsigned'}},
        if_not_exists = true,
        unique=true
    })


    -- create channel space
    -- sequence
    box.schema.sequence.create('channel', {if_not_exists=true})
    -- space
    box.schema.create_space('channel', {
        if_not_exists = true,
        format={
            {name='id', type='unsigned'},
            {name='external_id', type='string'},
            {name='type_id', type='unsigned'},
            {name='link', type='string'}
        }
    })
    box.space.channel:create_index('id', {
        type = 'tree',
        parts = {1, 'unsigned'},
        sequence='channel',
        if_not_exists = true,
        unique=true
    })
    box.space.channel:create_index('external_id_type_id', {
        type = 'tree',
        parts = {{2, 'string'}, {3, 'unsigned'}},
        if_not_exists = true,
        unique=true
    })

    -- create link space
    -- sequence
    box.schema.sequence.create('link', {if_not_exists=true})
    -- space
    box.schema.create_space('link', {
        if_not_exists = true,
        format={
            {name='id', type='unsigned'},
            {name='channel_id_from', type='unsigned'},
            {name='channel_id_to', type='unsigned'},
            {name='user_id', type='unsigned'}
        }
    })
    box.space.link:create_index('id', {
        type = 'tree',
        parts = {1, 'unsigned'},
        sequence='link',
        if_not_exists = true,
        unique=true
    })
    box.space.link:create_index('channel_id_from', {
        type = 'tree',
        parts = {2, 'unsigned'},
        if_not_exists = true,
        unique=false
    })
    box.space.link:create_index('channel_id_to', {
        type = 'tree',
        parts = {3, 'unsigned'},
        if_not_exists = true,
        unique=false
    })
    box.space.link:create_index('channel_id_from_to', {
        type = 'tree',
        parts = {{2, 'unsigned'},{3, 'unsigned'}},
        if_not_exists = true,
        unique=true
    })
    box.space.link:create_index('user_id', {
        type = 'tree',
        parts = {4, 'unsigned'},
        if_not_exists = true,
        unique=false
    })

end