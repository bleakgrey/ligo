project('com.github.bleakgrey.desidia', 'vala', 'c')

gnome = import('gnome')
i18n = import('i18n')

add_global_arguments([
        '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name())
    ],
    language: 'c',
)

# asresources = gnome.compile_resources(
#   'as-resources', 'data/' + meson.project_name() + '.gresource.xml',
#   source_dir: 'data',
#   c_name: 'as'
# )

cc = meson.get_compiler('c')
libmarkdown = cc.find_library('markdown', required: true)

add_project_arguments(['--vapidir', join_paths(meson.current_source_dir(), 'vapi')], language: 'vala')

executable(
    meson.project_name(),
    # asresources,
    'src/Application.vala',
    'src/Page.vala',
    'src/Project.vala',
    'src/Widgets/HeaderBar.vala',
    'src/Widgets/Sidebar.vala',
    'src/Widgets/Notebook.vala',
    'src/Widgets/EditorView.vala',
    'src/Windows/Main.vala',
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('glib-2.0', version: '>=2.30.0'),
        dependency('granite'),
        dependency('json-glib-1.0'),
        dependency('gtksourceview-3.0', version: '>=3.24'),
        libmarkdown,
    ],
    vala_args: [
        meson.source_root() + '/vapi/config.vapi',
        meson.source_root() + '/vapi/libmarkdown.vapi'
    ],
    install: true
)

# subdir('data')
# subdir('po')

meson.add_install_script('meson/post_install.py')
