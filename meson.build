project('com.github.bleakgrey.ligo', 'vala', 'c')

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
    'src/IO.vala',
    'src/Application.vala',
    'src/Pages.vala',
    'src/Pages/Base.vala',
    'src/Pages/Text.vala',
    'src/Pages/Paginated.vala',
    'src/Pages/Blog.vala',
    'src/Pages/BlogArticle.vala',
    'src/Theme.vala',
    'src/Project.vala',
    'src/Paginator.vala',
    'src/Widgets/HeaderBar.vala',
    'src/Widgets/Structure.vala',
    'src/Widgets/PageSettings.vala',
    'src/Widgets/Sidebar.vala',
    'src/Widgets/StatusBar.vala',
    'src/Widgets/Notebook.vala',
    'src/Widgets/SourceView.vala',
    'src/Widgets/Tabs/Base.vala',
    'src/Widgets/Tabs/Startup.vala',
    'src/Widgets/Tabs/PageEditor.vala',
    'src/Widgets/Tabs/BlogEditor.vala',
    'src/Widgets/Forms/Label.vala',
    'src/Widgets/Forms/StringEntry.vala',
    'src/Widgets/Forms/BooleanSwitch.vala',
    'src/Widgets/Forms/PermalinkEntry.vala',
    'src/Widgets/Forms/PageTypeSelector.vala',
    'src/Widgets/Forms/DatePicker.vala',
    'src/Widgets/Forms/IntSpinner.vala',
    'src/Windows/NewPage.vala',
    'src/Windows/Main.vala',
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('glib-2.0', version: '>=2.30.0'),
        dependency('gee-0.8', version: '>=0.8.5'),
        dependency('json-glib-1.0'),
        dependency('gtksourceview-3.0', version: '>=3.24'),
        dependency('gtkspell3-3.0'),
        dependency('granite'),
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
