/*
 * SEConstantGlue.m
 *
 * /System/Library/CoreServices/System Events.app
 * osaglue 0.2.0
 *
 */

#import "SEConstantGlue.h"

@implementation SEConstant

+ (id)constantWithCode:(OSType)code_ {
    switch (code_) {
        case 'dfas': return [self AppleShare_format];
        case 'dfph': return [self Apple_Photo_format];
        case 'dhao': return [self CD_and_DVD_preferences_object];
        case 'clsc': return [self Classic];
        case 'fldc': return [self Classic_domain];
        case 'domc': return [self Classic_domain_object];
        case 'F1ky': return [self F1];
        case 'F10k': return [self F10];
        case 'F11k': return [self F11];
        case 'F12k': return [self F12];
        case 'F13k': return [self F13];
        case 'F2ky': return [self F2];
        case 'F3ky': return [self F3];
        case 'F4ky': return [self F4];
        case 'F5ky': return [self F5];
        case 'F6ky': return [self F6];
        case 'F7ky': return [self F7];
        case 'F8ky': return [self F8];
        case 'F9ky': return [self F9];
        case 'fasf': return [self Folder_Action_scripts_folder];
        case 'dfhs': return [self High_Sierra_format];
        case 'df96': return [self ISO_9660_format];
        case 'maca': return [self MAC_address];
        case 'dfms': return [self MSDOS_format];
        case 'dfh+': return [self Mac_OS_Extended_format];
        case 'dfhf': return [self Mac_OS_format];
        case 'dfnf': return [self NFS_format];
        case 'posx': return [self POSIX_path];
        case 'dfpr': return [self ProDOS_format];
        case 'dfqt': return [self QuickTake_format];
        case 'qtfd': return [self QuickTime_data];
        case 'qtff': return [self QuickTime_file];
        case 'dfud': return [self UDF_format];
        case 'dfuf': return [self UFS_format];
        case 'uiel': return [self UI_element];
        case 'uien': return [self UI_elements_enabled];
        case 'url ': return [self URL];
        case 'dfwd': return [self WebDAV_format];
        case 'xmla': return [self XML_attribute];
        case 'xmld': return [self XML_data];
        case 'xmle': return [self XML_element];
        case 'xmlf': return [self XML_file];
        case 'isab': return [self accepts_high_level_events];
        case 'revt': return [self accepts_remote_events];
        case 'user': return [self account_name];
        case 'actT': return [self action];
        case 'acti': return [self active];
        case 'epsa': return [self activity];
        case 'alis': return [self alias];
        case 'allw': return [self all_windows];
        case 'epaw': return [self all_windows_shortcut];
        case 'dani': return [self animate];
        case 'anno': return [self annotation];
        case 'appe': return [self appearance];
        case 'aprp': return [self appearance_preferences];
        case 'apro': return [self appearance_preferences_object];
        case 'amnu': return [self apple_menu_folder];
        case 'capp': return [self application];
        case 'appf': return [self application_file];
        case 'pcap': return [self application_process];
        case 'asup': return [self application_support_folder];
        case 'appw': return [self application_windows];
        case 'eppw': return [self application_windows_shortcut];
        case 'apps': return [self applications_folder];
        case 'arch': return [self architecture];
        case 'spam': return [self arrow_key_modifiers];
        case 'ask ': return [self ask];
        case 'dhas': return [self ask_what_to_do];
        case 'atts': return [self attachment];
        case 'attr': return [self attribute];
        case 'catr': return [self attribute_run];
        case 'acha': return [self audio_channel_count];
        case 'audi': return [self audio_characteristic];
        case 'audd': return [self audio_data];
        case 'audf': return [self audio_file];
        case 'dfau': return [self audio_format];
        case 'asra': return [self audio_sample_rate];
        case 'assz': return [self audio_sample_size];
        case 'autp': return [self auto_play];
        case 'apre': return [self auto_present];
        case 'aqui': return [self auto_quit_when_done];
        case 'dahd': return [self autohide];
        case 'auto': return [self automatic];
        case 'autm': return [self automatic];
        case 'aulg': return [self automatic_login];
        case 'bkgo': return [self background_only];
        case 'dhbc': return [self blank_CD];
        case 'dhbd': return [self blank_DVD];
        case 'blue': return [self blue];
        case 'bott': return [self bottom];
        case 'epbl': return [self bottom_left_screen_corner];
        case 'epbr': return [self bottom_right_screen_corner];
        case 'pbnd': return [self bounds];
        case 'broW': return [self browser];
        case 'bnid': return [self bundle_identifier];
        case 'busi': return [self busy_indicator];
        case 'busy': return [self busy_status];
        case 'butT': return [self button];
        case 'capa': return [self capacity];
        case 'cinT': return [self change_interval];
        case 'cha ': return [self character];
        case 'chbx': return [self checkbox];
        case 'pcls': return [self class_];
        case 'hclb': return [self closeable];
        case 'lwcl': return [self collating];
        case 'colr': return [self color];
        case 'colW': return [self color_well];
        case 'ccol': return [self column];
        case 'comB': return [self combo_box];
        case 'cmdm': return [self command];
        case 'eCmd': return [self command];
        case 'Kcmd': return [self command_down];
        case 'conF': return [self configuration];
        case 'conn': return [self connected];
        case 'ctnr': return [self container];
        case 'pcnt': return [self contents];
        case 'eCnt': return [self control];
        case 'ctlm': return [self control];
        case 'Kctl': return [self control_down];
        case 'ctrl': return [self control_panels_folder];
        case 'sdev': return [self control_strip_modules_folder];
        case 'lwcp': return [self copies];
        case 'ascd': return [self creation_date];
        case 'mdcr': return [self creation_time];
        case 'fcrt': return [self creator_type];
        case 'cust': return [self current];
        case 'cnfg': return [self current_configuration];
        case 'curd': return [self current_desktop];
        case 'locc': return [self current_location];
        case 'curu': return [self current_user];
        case 'dhca': return [self custom_application];
        case 'dhcs': return [self custom_script];
        case 'dash': return [self dashboard];
        case 'epdb': return [self dashboard_shortcut];
        case 'tdfr': return [self data_format];
        case 'ddra': return [self data_rate];
        case 'dsiz': return [self data_size];
        case 'asda': return [self default_application];
        case 'desc': return [self description];
        case 'dafi': return [self desk_accessory_file];
        case 'pcda': return [self desk_accessory_process];
        case 'dskp': return [self desktop];
        case 'dtp$': return [self desktop_pictures_folder];
        case 'lwdt': return [self detailed];
        case 'pdim': return [self dimensions];
        case 'disc': return [self disable_screen_saver];
        case 'cdis': return [self disk];
        case 'ditm': return [self disk_item];
        case 'dnaM': return [self display_name];
        case 'dnam': return [self displayed_name];
        case 'dpas': return [self dock_preferences];
        case 'dpao': return [self dock_preferences_object];
        case 'dsze': return [self dock_size];
        case 'docu': return [self document];
        case 'docs': return [self documents_folder];
        case 'doma': return [self domain];
        case 'doub': return [self double];
        case 'mndc': return [self double_click_minimizes];
        case 'down': return [self downloads_folder];
        case 'draA': return [self drawer];
        case 'dupl': return [self duplex];
        case 'durn': return [self duration];
        case 'isej': return [self ejectable];
        case 'enaB': return [self enabled];
        case 'lwlp': return [self ending_page];
        case 'ects': return [self entire_contents];
        case 'lweh': return [self error_handling];
        case 'epas': return [self expose_preferences];
        case 'epao': return [self expose_preferences_object];
        case 'extz': return [self extensions_folder];
        case 'favs': return [self favorites_folder];
        case 'faxn': return [self fax_number];
        case 'file': return [self file];
        case 'atfn': return [self file_name];
        case 'cpkg': return [self file_package];
        case 'asty': return [self file_type];
        case 'isfl': return [self floating];
        case 'focu': return [self focused];
        case 'cfol': return [self folder];
        case 'foac': return [self folder_action];
        case 'faen': return [self folder_actions_enabled];
        case 'ftsm': return [self font_smoothing_limit];
        case 'ftss': return [self font_smoothing_style];
        case 'font': return [self fonts_folder];
        case 'dfmt': return [self format];
        case 'frsp': return [self free_space];
        case 'pisf': return [self frontmost];
        case 'fnam': return [self full_name];
        case 'anot': return [self full_text];
        case 'epsk': return [self function_key];
        case 'epsy': return [self function_key_modifiers];
        case 'geni': return [self genie];
        case 'gold': return [self gold];
        case 'grft': return [self graphite];
        case 'gren': return [self green];
        case 'sgrp': return [self group];
        case 'grow': return [self grow_area];
        case 'half': return [self half];
        case 'hscr': return [self has_scripting_terminology];
        case 'help': return [self help_];
        case 'hidn': return [self hidden];
        case 'hqua': return [self high_quality];
        case 'hico': return [self highlight_color];
        case 'home': return [self home_directory];
        case 'cusr': return [self home_folder];
        case 'href': return [self href];
        case 'ID  ': return [self id];
        case 'dhig': return [self ignore_];
        case 'igpr': return [self ignore_privileges];
        case 'imaA': return [self image];
        case 'incr': return [self incrementor];
        case 'pidx': return [self index];
        case 'dhat': return [self insertion_action];
        case 'dhip': return [self insertion_preference];
        case 'intf': return [self interface];
        case 'cobj': return [self item];
        case 'fget': return [self items_added];
        case 'flos': return [self items_removed];
        case 'tohr': return [self jump_to_here];
        case 'nxpg': return [self jump_to_next_page];
        case 'spky': return [self key_modifiers];
        case 'kind': return [self kind];
        case 'laun': return [self launcher_items_folder];
        case 'left': return [self left];
        case 'Lcmd': return [self left_command];
        case 'Lctl': return [self left_control];
        case 'Lopt': return [self left_option];
        case 'Lsht': return [self left_shift];
        case 'dlib': return [self library_folder];
        case 'lite': return [self light];
        case 'list': return [self list];
        case 'fldl': return [self local_domain];
        case 'doml': return [self local_domain_object];
        case 'isrv': return [self local_volume];
        case 'loca': return [self location];
        case 'dplo': return [self location];
        case 'aclk': return [self log_out_when_inactive];
        case 'acto': return [self log_out_when_inactive_interval];
        case 'logi': return [self login_item];
        case 'loop': return [self looping];
        case 'dmag': return [self magnification];
        case 'dmsz': return [self magnification_size];
        case 'maxV': return [self maximum_value];
        case 'medi': return [self medium];
        case 'menE': return [self menu];
        case 'mbar': return [self menu_bar];
        case 'mbri': return [self menu_bar_item];
        case 'menB': return [self menu_button];
        case 'menI': return [self menu_item];
        case 'ismn': return [self miniaturizable];
        case 'pmnd': return [self miniaturized];
        case 'deff': return [self minimize_effect];
        case 'minW': return [self minimum_value];
        case 'pmod': return [self modal];
        case 'asmo': return [self modification_date];
        case 'mdtm': return [self modification_time];
        case 'imod': return [self modified];
        case 'epso': return [self modifiers];
        case 'epsb': return [self mouse_button];
        case 'epsm': return [self mouse_button_modifiers];
        case 'movd': return [self movie_data];
        case 'movf': return [self movie_file];
        case 'mdoc': return [self movies_folder];
        case 'mtu ': return [self mtu];
        case 'dhmc': return [self music_CD];
        case '%doc': return [self music_folder];
        case 'pnam': return [self name];
        case 'extn': return [self name_extension];
        case 'ndim': return [self natural_dimensions];
        case 'fldn': return [self network_domain];
        case 'domn': return [self network_domain_object];
        case 'netp': return [self network_preferences];
        case 'neto': return [self network_preferences_object];
        case 'no  ': return [self no];
        case 'none': return [self none];
        case 'norm': return [self normal];
        case 'spnm': return [self numbers_key_modifiers];
        case 'dhap': return [self open_application];
        case 'optm': return [self option];
        case 'eOpt': return [self option];
        case 'Kopt': return [self option_down];
        case 'orng': return [self orange];
        case 'orie': return [self orientation];
        case 'outl': return [self outline];
        case 'pkgf': return [self package_folder];
        case 'lwla': return [self pages_across];
        case 'lwld': return [self pages_down];
        case 'cpar': return [self paragraph];
        case 'pusd': return [self partition_space_used];
        case 'ppth': return [self path];
        case 'phys': return [self physical_size];
        case 'picP': return [self picture];
        case 'dhpc': return [self picture_CD];
        case 'picp': return [self picture_path];
        case 'chnG': return [self picture_rotation];
        case 'pdoc': return [self pictures_folder];
        case 'popB': return [self pop_up_button];
        case 'posn': return [self position];
        case 'pref': return [self preferences_folder];
        case 'prfr': return [self preferred_rate];
        case 'prfv': return [self preferred_volume];
        case 'prmd': return [self presentation_mode];
        case 'prsz': return [self presentation_size];
        case 'pvwd': return [self preview_duration];
        case 'pvwt': return [self preview_time];
        case 'pset': return [self print_settings];
        case 'prcs': return [self process];
        case 'ver2': return [self product_version];
        case 'proI': return [self progress_indicator];
        case 'pALL': return [self properties];
        case 'plif': return [self property_list_file];
        case 'plii': return [self property_list_item];
        case 'pubb': return [self public_folder];
        case 'prpl': return [self purple];
        case 'qdel': return [self quit_delay];
        case 'radB': return [self radio_button];
        case 'rgrp': return [self radio_group];
        case 'ranD': return [self random_order];
        case 'rapl': return [self recent_applications_limit];
        case 'rdcl': return [self recent_documents_limit];
        case 'rsvl': return [self recent_servers_limit];
        case 'red ': return [self red];
        case 'reli': return [self relevance_indicator];
        case 'lwqt': return [self requested_print_time];
        case 'pwul': return [self require_password_to_unlock];
        case 'pwwk': return [self require_password_to_wake];
        case 'righ': return [self right];
        case 'Rcmd': return [self right_command];
        case 'Rctl': return [self right_control];
        case 'Ropt': return [self right_option];
        case 'Rsht': return [self right_shift];
        case 'role': return [self role];
        case 'crow': return [self row];
        case 'dhrs': return [self run_a_script];
        case 'scal': return [self scale];
        case 'fits': return [self screen];
        case 'epsc': return [self screen_corner];
        case 'scpt': return [self script];
        case 'scmn': return [self script_menu_enabled];
        case '$scr': return [self scripting_additions_folder];
        case 'scr$': return [self scripts_folder];
        case 'scra': return [self scroll_area];
        case 'sclp': return [self scroll_arrow_placement];
        case 'scrb': return [self scroll_bar];
        case 'sclb': return [self scroll_bar_action];
        case 'SFky': return [self secondary_function_key];
        case 'scvm': return [self secure_virtual_memory];
        case 'secp': return [self security_preferences];
        case 'seco': return [self security_preferences_object];
        case 'selE': return [self selected];
        case 'srvr': return [self server];
        case 'svce': return [self service];
        case 'stbl': return [self settable];
        case 'sdat': return [self shared_documents_folder];
        case 'sheE': return [self sheet];
        case 'shtm': return [self shift];
        case 'eSft': return [self shift];
        case 'Ksft': return [self shift_down];
        case 'cfbn': return [self short_name];
        case 'assv': return [self short_version];
        case 'epst': return [self shortcut];
        case 'desk': return [self show_desktop];
        case 'epde': return [self show_desktop_shortcut];
        case 'spcs': return [self show_spaces];
        case 'shdf': return [self shutdown_folder];
        case 'slvr': return [self silver];
        case 'site': return [self sites_folder];
        case 'ptsz': return [self size];
        case 'diss': return [self sleep_display];
        case 'pmss': return [self slide_show];
        case 'sliI': return [self slider];
        case 'scls': return [self smooth_scrolling];
        case 'spcl': return [self spaces_columns];
        case 'spen': return [self spaces_enabled];
        case 'essp': return [self spaces_preferences];
        case 'spsp': return [self spaces_preferences_object];
        case 'sprw': return [self spaces_rows];
        case 'spst': return [self spaces_shortcut];
        case 'spki': return [self speakable_items_folder];
        case 'sped': return [self speed];
        case 'splr': return [self splitter];
        case 'splg': return [self splitter_group];
        case 'lwst': return [self standard];
        case 'stnd': return [self standard];
        case 'star': return [self start_screen_saver];
        case 'offs': return [self start_time];
        case 'lwfp': return [self starting_page];
        case 'istd': return [self startup];
        case 'sdsk': return [self startup_disk];
        case 'empz': return [self startup_items_folder];
        case 'sttx': return [self static_text];
        case 'pspd': return [self stationery];
        case 'isss': return [self stored_stream];
        case 'strg': return [self strong];
        case 'sbrl': return [self subrole];
        case 'flds': return [self system_domain];
        case 'doms': return [self system_domain_object];
        case 'macs': return [self system_folder];
        case 'tabg': return [self tab_group];
        case 'tabB': return [self table];
        case 'trpr': return [self target_printer];
        case 'temp': return [self temporary_items_folder];
        case 'ctxt': return [self text];
        case 'txta': return [self text_area];
        case 'txtf': return [self text_field];
        case 'tmsc': return [self time_scale];
        case 'titl': return [self title];
        case 'ptit': return [self titled];
        case 'tgth': return [self together];
        case 'tgtb': return [self together_at_top_and_bottom];
        case 'tbar': return [self tool_bar];
        case 'tpbt': return [self top_and_bottom];
        case 'eptl': return [self top_left_screen_corner];
        case 'eptr': return [self top_right_screen_corner];
        case 'appt': return [self total_partition_size];
        case 'trak': return [self track];
        case 'trsh': return [self trash];
        case 'ptyp': return [self type];
        case 'type': return [self type_class];
        case 'utid': return [self type_identifier];
        case 'idux': return [self unix_id];
        case 'df$$': return [self unknown_format];
        case 'uacc': return [self user];
        case 'fldu': return [self user_domain];
        case 'domu': return [self user_domain_object];
        case 'uti$': return [self utilities_folder];
        case 'valL': return [self value];
        case 'vali': return [self value_indicator];
        case 'vers': return [self version];
        case 'dhvd': return [self video_DVD];
        case 'vcdp': return [self video_depth];
        case 'pvis': return [self visible];
        case 'visu': return [self visual_characteristic];
        case 'volu': return [self volume];
        case 'cwin': return [self window];
        case 'fclo': return [self window_closed];
        case 'fsiz': return [self window_moved];
        case 'fopn': return [self window_opened];
        case 'cwor': return [self word];
        case 'flow': return [self workflows_folder];
        case 'yes ': return [self yes];
        case 'zone': return [self zone];
        case 'iszm': return [self zoomable];
        case 'pzum': return [self zoomed];
        default: return [[self superclass] constantWithCode: code_];
    }
}


/* Enumerators */

+ (SEConstant *)AppleShare_format {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"AppleShare_format" type: typeEnumerated code: 'dfas'];
    return constantObj;
}

+ (SEConstant *)Apple_Photo_format {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"Apple_Photo_format" type: typeEnumerated code: 'dfph'];
    return constantObj;
}

+ (SEConstant *)F1 {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"F1" type: typeEnumerated code: 'F1ky'];
    return constantObj;
}

+ (SEConstant *)F10 {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"F10" type: typeEnumerated code: 'F10k'];
    return constantObj;
}

+ (SEConstant *)F11 {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"F11" type: typeEnumerated code: 'F11k'];
    return constantObj;
}

+ (SEConstant *)F12 {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"F12" type: typeEnumerated code: 'F12k'];
    return constantObj;
}

+ (SEConstant *)F13 {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"F13" type: typeEnumerated code: 'F13k'];
    return constantObj;
}

+ (SEConstant *)F2 {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"F2" type: typeEnumerated code: 'F2ky'];
    return constantObj;
}

+ (SEConstant *)F3 {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"F3" type: typeEnumerated code: 'F3ky'];
    return constantObj;
}

+ (SEConstant *)F4 {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"F4" type: typeEnumerated code: 'F4ky'];
    return constantObj;
}

+ (SEConstant *)F5 {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"F5" type: typeEnumerated code: 'F5ky'];
    return constantObj;
}

+ (SEConstant *)F6 {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"F6" type: typeEnumerated code: 'F6ky'];
    return constantObj;
}

+ (SEConstant *)F7 {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"F7" type: typeEnumerated code: 'F7ky'];
    return constantObj;
}

+ (SEConstant *)F8 {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"F8" type: typeEnumerated code: 'F8ky'];
    return constantObj;
}

+ (SEConstant *)F9 {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"F9" type: typeEnumerated code: 'F9ky'];
    return constantObj;
}

+ (SEConstant *)High_Sierra_format {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"High_Sierra_format" type: typeEnumerated code: 'dfhs'];
    return constantObj;
}

+ (SEConstant *)ISO_9660_format {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"ISO_9660_format" type: typeEnumerated code: 'df96'];
    return constantObj;
}

+ (SEConstant *)MSDOS_format {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"MSDOS_format" type: typeEnumerated code: 'dfms'];
    return constantObj;
}

+ (SEConstant *)Mac_OS_Extended_format {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"Mac_OS_Extended_format" type: typeEnumerated code: 'dfh+'];
    return constantObj;
}

+ (SEConstant *)Mac_OS_format {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"Mac_OS_format" type: typeEnumerated code: 'dfhf'];
    return constantObj;
}

+ (SEConstant *)NFS_format {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"NFS_format" type: typeEnumerated code: 'dfnf'];
    return constantObj;
}

+ (SEConstant *)ProDOS_format {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"ProDOS_format" type: typeEnumerated code: 'dfpr'];
    return constantObj;
}

+ (SEConstant *)QuickTake_format {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"QuickTake_format" type: typeEnumerated code: 'dfqt'];
    return constantObj;
}

+ (SEConstant *)UDF_format {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"UDF_format" type: typeEnumerated code: 'dfud'];
    return constantObj;
}

+ (SEConstant *)UFS_format {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"UFS_format" type: typeEnumerated code: 'dfuf'];
    return constantObj;
}

+ (SEConstant *)WebDAV_format {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"WebDAV_format" type: typeEnumerated code: 'dfwd'];
    return constantObj;
}

+ (SEConstant *)all_windows {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"all_windows" type: typeEnumerated code: 'allw'];
    return constantObj;
}

+ (SEConstant *)application_windows {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"application_windows" type: typeEnumerated code: 'appw'];
    return constantObj;
}

+ (SEConstant *)ask {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"ask" type: typeEnumerated code: 'ask '];
    return constantObj;
}

+ (SEConstant *)ask_what_to_do {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"ask_what_to_do" type: typeEnumerated code: 'dhas'];
    return constantObj;
}

+ (SEConstant *)audio_format {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"audio_format" type: typeEnumerated code: 'dfau'];
    return constantObj;
}

+ (SEConstant *)automatic {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"automatic" type: typeEnumerated code: 'autm'];
    return constantObj;
}

+ (SEConstant *)blue {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"blue" type: typeEnumerated code: 'blue'];
    return constantObj;
}

+ (SEConstant *)bottom {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"bottom" type: typeEnumerated code: 'bott'];
    return constantObj;
}

+ (SEConstant *)command {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"command" type: typeEnumerated code: 'cmdm'];
    return constantObj;
}

+ (SEConstant *)command_down {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"command_down" type: typeEnumerated code: 'Kcmd'];
    return constantObj;
}

+ (SEConstant *)control {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"control" type: typeEnumerated code: 'ctlm'];
    return constantObj;
}

+ (SEConstant *)control_down {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"control_down" type: typeEnumerated code: 'Kctl'];
    return constantObj;
}

+ (SEConstant *)current {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"current" type: typeEnumerated code: 'cust'];
    return constantObj;
}

+ (SEConstant *)dashboard {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"dashboard" type: typeEnumerated code: 'dash'];
    return constantObj;
}

+ (SEConstant *)detailed {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"detailed" type: typeEnumerated code: 'lwdt'];
    return constantObj;
}

+ (SEConstant *)disable_screen_saver {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"disable_screen_saver" type: typeEnumerated code: 'disc'];
    return constantObj;
}

+ (SEConstant *)double {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"double" type: typeEnumerated code: 'doub'];
    return constantObj;
}

+ (SEConstant *)genie {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"genie" type: typeEnumerated code: 'geni'];
    return constantObj;
}

+ (SEConstant *)gold {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"gold" type: typeEnumerated code: 'gold'];
    return constantObj;
}

+ (SEConstant *)graphite {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"graphite" type: typeEnumerated code: 'grft'];
    return constantObj;
}

+ (SEConstant *)green {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"green" type: typeEnumerated code: 'gren'];
    return constantObj;
}

+ (SEConstant *)half {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"half" type: typeEnumerated code: 'half'];
    return constantObj;
}

+ (SEConstant *)ignore_ {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"ignore_" type: typeEnumerated code: 'dhig'];
    return constantObj;
}

+ (SEConstant *)items_added {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"items_added" type: typeEnumerated code: 'fget'];
    return constantObj;
}

+ (SEConstant *)items_removed {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"items_removed" type: typeEnumerated code: 'flos'];
    return constantObj;
}

+ (SEConstant *)jump_to_here {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"jump_to_here" type: typeEnumerated code: 'tohr'];
    return constantObj;
}

+ (SEConstant *)jump_to_next_page {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"jump_to_next_page" type: typeEnumerated code: 'nxpg'];
    return constantObj;
}

+ (SEConstant *)left {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"left" type: typeEnumerated code: 'left'];
    return constantObj;
}

+ (SEConstant *)left_command {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"left_command" type: typeEnumerated code: 'Lcmd'];
    return constantObj;
}

+ (SEConstant *)left_control {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"left_control" type: typeEnumerated code: 'Lctl'];
    return constantObj;
}

+ (SEConstant *)left_option {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"left_option" type: typeEnumerated code: 'Lopt'];
    return constantObj;
}

+ (SEConstant *)left_shift {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"left_shift" type: typeEnumerated code: 'Lsht'];
    return constantObj;
}

+ (SEConstant *)light {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"light" type: typeEnumerated code: 'lite'];
    return constantObj;
}

+ (SEConstant *)medium {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"medium" type: typeEnumerated code: 'medi'];
    return constantObj;
}

+ (SEConstant *)no {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"no" type: typeEnumerated code: 'no  '];
    return constantObj;
}

+ (SEConstant *)none {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"none" type: typeEnumerated code: 'none'];
    return constantObj;
}

+ (SEConstant *)normal {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"normal" type: typeEnumerated code: 'norm'];
    return constantObj;
}

+ (SEConstant *)open_application {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"open_application" type: typeEnumerated code: 'dhap'];
    return constantObj;
}

+ (SEConstant *)option {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"option" type: typeEnumerated code: 'optm'];
    return constantObj;
}

+ (SEConstant *)option_down {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"option_down" type: typeEnumerated code: 'Kopt'];
    return constantObj;
}

+ (SEConstant *)orange {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"orange" type: typeEnumerated code: 'orng'];
    return constantObj;
}

+ (SEConstant *)purple {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"purple" type: typeEnumerated code: 'prpl'];
    return constantObj;
}

+ (SEConstant *)red {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"red" type: typeEnumerated code: 'red '];
    return constantObj;
}

+ (SEConstant *)right {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"right" type: typeEnumerated code: 'righ'];
    return constantObj;
}

+ (SEConstant *)right_command {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"right_command" type: typeEnumerated code: 'Rcmd'];
    return constantObj;
}

+ (SEConstant *)right_control {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"right_control" type: typeEnumerated code: 'Rctl'];
    return constantObj;
}

+ (SEConstant *)right_option {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"right_option" type: typeEnumerated code: 'Ropt'];
    return constantObj;
}

+ (SEConstant *)right_shift {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"right_shift" type: typeEnumerated code: 'Rsht'];
    return constantObj;
}

+ (SEConstant *)run_a_script {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"run_a_script" type: typeEnumerated code: 'dhrs'];
    return constantObj;
}

+ (SEConstant *)scale {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"scale" type: typeEnumerated code: 'scal'];
    return constantObj;
}

+ (SEConstant *)screen {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"screen" type: typeEnumerated code: 'fits'];
    return constantObj;
}

+ (SEConstant *)secondary_function_key {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"secondary_function_key" type: typeEnumerated code: 'SFky'];
    return constantObj;
}

+ (SEConstant *)shift {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"shift" type: typeEnumerated code: 'shtm'];
    return constantObj;
}

+ (SEConstant *)shift_down {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"shift_down" type: typeEnumerated code: 'Ksft'];
    return constantObj;
}

+ (SEConstant *)show_desktop {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"show_desktop" type: typeEnumerated code: 'desk'];
    return constantObj;
}

+ (SEConstant *)show_spaces {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"show_spaces" type: typeEnumerated code: 'spcs'];
    return constantObj;
}

+ (SEConstant *)silver {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"silver" type: typeEnumerated code: 'slvr'];
    return constantObj;
}

+ (SEConstant *)sleep_display {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"sleep_display" type: typeEnumerated code: 'diss'];
    return constantObj;
}

+ (SEConstant *)slide_show {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"slide_show" type: typeEnumerated code: 'pmss'];
    return constantObj;
}

+ (SEConstant *)standard {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"standard" type: typeEnumerated code: 'stnd'];
    return constantObj;
}

+ (SEConstant *)start_screen_saver {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"start_screen_saver" type: typeEnumerated code: 'star'];
    return constantObj;
}

+ (SEConstant *)strong {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"strong" type: typeEnumerated code: 'strg'];
    return constantObj;
}

+ (SEConstant *)together {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"together" type: typeEnumerated code: 'tgth'];
    return constantObj;
}

+ (SEConstant *)together_at_top_and_bottom {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"together_at_top_and_bottom" type: typeEnumerated code: 'tgtb'];
    return constantObj;
}

+ (SEConstant *)top_and_bottom {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"top_and_bottom" type: typeEnumerated code: 'tpbt'];
    return constantObj;
}

+ (SEConstant *)unknown_format {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"unknown_format" type: typeEnumerated code: 'df$$'];
    return constantObj;
}

+ (SEConstant *)window_closed {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"window_closed" type: typeEnumerated code: 'fclo'];
    return constantObj;
}

+ (SEConstant *)window_moved {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"window_moved" type: typeEnumerated code: 'fsiz'];
    return constantObj;
}

+ (SEConstant *)window_opened {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"window_opened" type: typeEnumerated code: 'fopn'];
    return constantObj;
}

+ (SEConstant *)yes {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"yes" type: typeEnumerated code: 'yes '];
    return constantObj;
}


/* Types and properties */

+ (SEConstant *)CD_and_DVD_preferences {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"CD_and_DVD_preferences" type: typeType code: 'dhas'];
    return constantObj;
}

+ (SEConstant *)CD_and_DVD_preferences_object {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"CD_and_DVD_preferences_object" type: typeType code: 'dhao'];
    return constantObj;
}

+ (SEConstant *)Classic {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"Classic" type: typeType code: 'clsc'];
    return constantObj;
}

+ (SEConstant *)Classic_domain {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"Classic_domain" type: typeType code: 'fldc'];
    return constantObj;
}

+ (SEConstant *)Classic_domain_object {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"Classic_domain_object" type: typeType code: 'domc'];
    return constantObj;
}

+ (SEConstant *)Folder_Action_scripts_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"Folder_Action_scripts_folder" type: typeType code: 'fasf'];
    return constantObj;
}

+ (SEConstant *)MAC_address {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"MAC_address" type: typeType code: 'maca'];
    return constantObj;
}

+ (SEConstant *)POSIX_path {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"POSIX_path" type: typeType code: 'posx'];
    return constantObj;
}

+ (SEConstant *)QuickTime_data {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"QuickTime_data" type: typeType code: 'qtfd'];
    return constantObj;
}

+ (SEConstant *)QuickTime_file {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"QuickTime_file" type: typeType code: 'qtff'];
    return constantObj;
}

+ (SEConstant *)UI_element {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"UI_element" type: typeType code: 'uiel'];
    return constantObj;
}

+ (SEConstant *)UI_elements_enabled {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"UI_elements_enabled" type: typeType code: 'uien'];
    return constantObj;
}

+ (SEConstant *)URL {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"URL" type: typeType code: 'url '];
    return constantObj;
}

+ (SEConstant *)XML_attribute {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"XML_attribute" type: typeType code: 'xmla'];
    return constantObj;
}

+ (SEConstant *)XML_data {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"XML_data" type: typeType code: 'xmld'];
    return constantObj;
}

+ (SEConstant *)XML_element {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"XML_element" type: typeType code: 'xmle'];
    return constantObj;
}

+ (SEConstant *)XML_file {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"XML_file" type: typeType code: 'xmlf'];
    return constantObj;
}

+ (SEConstant *)accepts_high_level_events {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"accepts_high_level_events" type: typeType code: 'isab'];
    return constantObj;
}

+ (SEConstant *)accepts_remote_events {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"accepts_remote_events" type: typeType code: 'revt'];
    return constantObj;
}

+ (SEConstant *)account_name {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"account_name" type: typeType code: 'user'];
    return constantObj;
}

+ (SEConstant *)action {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"action" type: typeType code: 'actT'];
    return constantObj;
}

+ (SEConstant *)active {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"active" type: typeType code: 'acti'];
    return constantObj;
}

+ (SEConstant *)activity {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"activity" type: typeType code: 'epsa'];
    return constantObj;
}

+ (SEConstant *)alias {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"alias" type: typeType code: 'alis'];
    return constantObj;
}

+ (SEConstant *)all_windows_shortcut {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"all_windows_shortcut" type: typeType code: 'epaw'];
    return constantObj;
}

+ (SEConstant *)animate {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"animate" type: typeType code: 'dani'];
    return constantObj;
}

+ (SEConstant *)annotation {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"annotation" type: typeType code: 'anno'];
    return constantObj;
}

+ (SEConstant *)appearance {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"appearance" type: typeType code: 'appe'];
    return constantObj;
}

+ (SEConstant *)appearance_preferences {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"appearance_preferences" type: typeType code: 'aprp'];
    return constantObj;
}

+ (SEConstant *)appearance_preferences_object {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"appearance_preferences_object" type: typeType code: 'apro'];
    return constantObj;
}

+ (SEConstant *)apple_menu_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"apple_menu_folder" type: typeType code: 'amnu'];
    return constantObj;
}

+ (SEConstant *)application {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"application" type: typeType code: 'capp'];
    return constantObj;
}

+ (SEConstant *)application_bindings {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"application_bindings" type: typeType code: 'spcs'];
    return constantObj;
}

+ (SEConstant *)application_file {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"application_file" type: typeType code: 'appf'];
    return constantObj;
}

+ (SEConstant *)application_process {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"application_process" type: typeType code: 'pcap'];
    return constantObj;
}

+ (SEConstant *)application_support_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"application_support_folder" type: typeType code: 'asup'];
    return constantObj;
}

+ (SEConstant *)application_windows_shortcut {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"application_windows_shortcut" type: typeType code: 'eppw'];
    return constantObj;
}

+ (SEConstant *)applications_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"applications_folder" type: typeType code: 'apps'];
    return constantObj;
}

+ (SEConstant *)architecture {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"architecture" type: typeType code: 'arch'];
    return constantObj;
}

+ (SEConstant *)arrow_key_modifiers {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"arrow_key_modifiers" type: typeType code: 'spam'];
    return constantObj;
}

+ (SEConstant *)attachment {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"attachment" type: typeType code: 'atts'];
    return constantObj;
}

+ (SEConstant *)attribute {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"attribute" type: typeType code: 'attr'];
    return constantObj;
}

+ (SEConstant *)attribute_run {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"attribute_run" type: typeType code: 'catr'];
    return constantObj;
}

+ (SEConstant *)audio_channel_count {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"audio_channel_count" type: typeType code: 'acha'];
    return constantObj;
}

+ (SEConstant *)audio_characteristic {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"audio_characteristic" type: typeType code: 'audi'];
    return constantObj;
}

+ (SEConstant *)audio_data {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"audio_data" type: typeType code: 'audd'];
    return constantObj;
}

+ (SEConstant *)audio_file {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"audio_file" type: typeType code: 'audf'];
    return constantObj;
}

+ (SEConstant *)audio_sample_rate {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"audio_sample_rate" type: typeType code: 'asra'];
    return constantObj;
}

+ (SEConstant *)audio_sample_size {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"audio_sample_size" type: typeType code: 'assz'];
    return constantObj;
}

+ (SEConstant *)auto_play {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"auto_play" type: typeType code: 'autp'];
    return constantObj;
}

+ (SEConstant *)auto_present {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"auto_present" type: typeType code: 'apre'];
    return constantObj;
}

+ (SEConstant *)auto_quit_when_done {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"auto_quit_when_done" type: typeType code: 'aqui'];
    return constantObj;
}

+ (SEConstant *)autohide {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"autohide" type: typeType code: 'dahd'];
    return constantObj;
}

+ (SEConstant *)automatic_login {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"automatic_login" type: typeType code: 'aulg'];
    return constantObj;
}

+ (SEConstant *)background_only {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"background_only" type: typeType code: 'bkgo'];
    return constantObj;
}

+ (SEConstant *)blank_CD {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"blank_CD" type: typeType code: 'dhbc'];
    return constantObj;
}

+ (SEConstant *)blank_DVD {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"blank_DVD" type: typeType code: 'dhbd'];
    return constantObj;
}

+ (SEConstant *)bottom_left_screen_corner {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"bottom_left_screen_corner" type: typeType code: 'epbl'];
    return constantObj;
}

+ (SEConstant *)bottom_right_screen_corner {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"bottom_right_screen_corner" type: typeType code: 'epbr'];
    return constantObj;
}

+ (SEConstant *)bounds {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"bounds" type: typeType code: 'pbnd'];
    return constantObj;
}

+ (SEConstant *)browser {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"browser" type: typeType code: 'broW'];
    return constantObj;
}

+ (SEConstant *)bundle_identifier {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"bundle_identifier" type: typeType code: 'bnid'];
    return constantObj;
}

+ (SEConstant *)busy_indicator {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"busy_indicator" type: typeType code: 'busi'];
    return constantObj;
}

+ (SEConstant *)busy_status {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"busy_status" type: typeType code: 'busy'];
    return constantObj;
}

+ (SEConstant *)button {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"button" type: typeType code: 'butT'];
    return constantObj;
}

+ (SEConstant *)capacity {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"capacity" type: typeType code: 'capa'];
    return constantObj;
}

+ (SEConstant *)change_interval {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"change_interval" type: typeType code: 'cinT'];
    return constantObj;
}

+ (SEConstant *)character {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"character" type: typeType code: 'cha '];
    return constantObj;
}

+ (SEConstant *)checkbox {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"checkbox" type: typeType code: 'chbx'];
    return constantObj;
}

+ (SEConstant *)class_ {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"class_" type: typeType code: 'pcls'];
    return constantObj;
}

+ (SEConstant *)closeable {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"closeable" type: typeType code: 'hclb'];
    return constantObj;
}

+ (SEConstant *)collating {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"collating" type: typeType code: 'lwcl'];
    return constantObj;
}

+ (SEConstant *)color {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"color" type: typeType code: 'colr'];
    return constantObj;
}

+ (SEConstant *)color_well {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"color_well" type: typeType code: 'colW'];
    return constantObj;
}

+ (SEConstant *)column {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"column" type: typeType code: 'ccol'];
    return constantObj;
}

+ (SEConstant *)combo_box {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"combo_box" type: typeType code: 'comB'];
    return constantObj;
}

+ (SEConstant *)configuration {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"configuration" type: typeType code: 'conF'];
    return constantObj;
}

+ (SEConstant *)connected {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"connected" type: typeType code: 'conn'];
    return constantObj;
}

+ (SEConstant *)container {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"container" type: typeType code: 'ctnr'];
    return constantObj;
}

+ (SEConstant *)contents {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"contents" type: typeType code: 'pcnt'];
    return constantObj;
}

+ (SEConstant *)control_panels_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"control_panels_folder" type: typeType code: 'ctrl'];
    return constantObj;
}

+ (SEConstant *)control_strip_modules_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"control_strip_modules_folder" type: typeType code: 'sdev'];
    return constantObj;
}

+ (SEConstant *)copies {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"copies" type: typeType code: 'lwcp'];
    return constantObj;
}

+ (SEConstant *)creation_date {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"creation_date" type: typeType code: 'ascd'];
    return constantObj;
}

+ (SEConstant *)creation_time {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"creation_time" type: typeType code: 'mdcr'];
    return constantObj;
}

+ (SEConstant *)creator_type {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"creator_type" type: typeType code: 'fcrt'];
    return constantObj;
}

+ (SEConstant *)current_configuration {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"current_configuration" type: typeType code: 'cnfg'];
    return constantObj;
}

+ (SEConstant *)current_desktop {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"current_desktop" type: typeType code: 'curd'];
    return constantObj;
}

+ (SEConstant *)current_location {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"current_location" type: typeType code: 'locc'];
    return constantObj;
}

+ (SEConstant *)current_user {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"current_user" type: typeType code: 'curu'];
    return constantObj;
}

+ (SEConstant *)custom_application {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"custom_application" type: typeType code: 'dhca'];
    return constantObj;
}

+ (SEConstant *)custom_script {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"custom_script" type: typeType code: 'dhcs'];
    return constantObj;
}

+ (SEConstant *)dashboard_shortcut {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"dashboard_shortcut" type: typeType code: 'epdb'];
    return constantObj;
}

+ (SEConstant *)data_format {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"data_format" type: typeType code: 'tdfr'];
    return constantObj;
}

+ (SEConstant *)data_rate {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"data_rate" type: typeType code: 'ddra'];
    return constantObj;
}

+ (SEConstant *)data_size {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"data_size" type: typeType code: 'dsiz'];
    return constantObj;
}

+ (SEConstant *)default_application {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"default_application" type: typeType code: 'asda'];
    return constantObj;
}

+ (SEConstant *)description {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"description" type: typeType code: 'desc'];
    return constantObj;
}

+ (SEConstant *)desk_accessory_file {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"desk_accessory_file" type: typeType code: 'dafi'];
    return constantObj;
}

+ (SEConstant *)desk_accessory_process {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"desk_accessory_process" type: typeType code: 'pcda'];
    return constantObj;
}

+ (SEConstant *)desktop {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"desktop" type: typeType code: 'dskp'];
    return constantObj;
}

+ (SEConstant *)desktop_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"desktop_folder" type: typeType code: 'desk'];
    return constantObj;
}

+ (SEConstant *)desktop_pictures_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"desktop_pictures_folder" type: typeType code: 'dtp$'];
    return constantObj;
}

+ (SEConstant *)dimensions {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"dimensions" type: typeType code: 'pdim'];
    return constantObj;
}

+ (SEConstant *)disk {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"disk" type: typeType code: 'cdis'];
    return constantObj;
}

+ (SEConstant *)disk_item {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"disk_item" type: typeType code: 'ditm'];
    return constantObj;
}

+ (SEConstant *)display_name {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"display_name" type: typeType code: 'dnaM'];
    return constantObj;
}

+ (SEConstant *)displayed_name {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"displayed_name" type: typeType code: 'dnam'];
    return constantObj;
}

+ (SEConstant *)dock_preferences {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"dock_preferences" type: typeType code: 'dpas'];
    return constantObj;
}

+ (SEConstant *)dock_preferences_object {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"dock_preferences_object" type: typeType code: 'dpao'];
    return constantObj;
}

+ (SEConstant *)dock_size {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"dock_size" type: typeType code: 'dsze'];
    return constantObj;
}

+ (SEConstant *)document {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"document" type: typeType code: 'docu'];
    return constantObj;
}

+ (SEConstant *)documents_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"documents_folder" type: typeType code: 'docs'];
    return constantObj;
}

+ (SEConstant *)domain {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"domain" type: typeType code: 'doma'];
    return constantObj;
}

+ (SEConstant *)double_click_minimizes {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"double_click_minimizes" type: typeType code: 'mndc'];
    return constantObj;
}

+ (SEConstant *)downloads_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"downloads_folder" type: typeType code: 'down'];
    return constantObj;
}

+ (SEConstant *)drawer {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"drawer" type: typeType code: 'draA'];
    return constantObj;
}

+ (SEConstant *)duplex {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"duplex" type: typeType code: 'dupl'];
    return constantObj;
}

+ (SEConstant *)duration {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"duration" type: typeType code: 'durn'];
    return constantObj;
}

+ (SEConstant *)ejectable {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"ejectable" type: typeType code: 'isej'];
    return constantObj;
}

+ (SEConstant *)enabled {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"enabled" type: typeType code: 'enaB'];
    return constantObj;
}

+ (SEConstant *)ending_page {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"ending_page" type: typeType code: 'lwlp'];
    return constantObj;
}

+ (SEConstant *)entire_contents {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"entire_contents" type: typeType code: 'ects'];
    return constantObj;
}

+ (SEConstant *)error_handling {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"error_handling" type: typeType code: 'lweh'];
    return constantObj;
}

+ (SEConstant *)expose_preferences {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"expose_preferences" type: typeType code: 'epas'];
    return constantObj;
}

+ (SEConstant *)expose_preferences_object {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"expose_preferences_object" type: typeType code: 'epao'];
    return constantObj;
}

+ (SEConstant *)extensions_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"extensions_folder" type: typeType code: 'extz'];
    return constantObj;
}

+ (SEConstant *)favorites_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"favorites_folder" type: typeType code: 'favs'];
    return constantObj;
}

+ (SEConstant *)fax_number {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"fax_number" type: typeType code: 'faxn'];
    return constantObj;
}

+ (SEConstant *)file {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"file" type: typeType code: 'file'];
    return constantObj;
}

+ (SEConstant *)file_name {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"file_name" type: typeType code: 'atfn'];
    return constantObj;
}

+ (SEConstant *)file_package {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"file_package" type: typeType code: 'cpkg'];
    return constantObj;
}

+ (SEConstant *)file_type {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"file_type" type: typeType code: 'asty'];
    return constantObj;
}

+ (SEConstant *)floating {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"floating" type: typeType code: 'isfl'];
    return constantObj;
}

+ (SEConstant *)focused {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"focused" type: typeType code: 'focu'];
    return constantObj;
}

+ (SEConstant *)folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"folder" type: typeType code: 'cfol'];
    return constantObj;
}

+ (SEConstant *)folder_action {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"folder_action" type: typeType code: 'foac'];
    return constantObj;
}

+ (SEConstant *)folder_actions_enabled {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"folder_actions_enabled" type: typeType code: 'faen'];
    return constantObj;
}

+ (SEConstant *)font {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"font" type: typeType code: 'font'];
    return constantObj;
}

+ (SEConstant *)font_smoothing_limit {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"font_smoothing_limit" type: typeType code: 'ftsm'];
    return constantObj;
}

+ (SEConstant *)font_smoothing_style {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"font_smoothing_style" type: typeType code: 'ftss'];
    return constantObj;
}

+ (SEConstant *)fonts_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"fonts_folder" type: typeType code: 'font'];
    return constantObj;
}

+ (SEConstant *)format {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"format" type: typeType code: 'dfmt'];
    return constantObj;
}

+ (SEConstant *)free_space {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"free_space" type: typeType code: 'frsp'];
    return constantObj;
}

+ (SEConstant *)frontmost {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"frontmost" type: typeType code: 'pisf'];
    return constantObj;
}

+ (SEConstant *)full_name {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"full_name" type: typeType code: 'fnam'];
    return constantObj;
}

+ (SEConstant *)full_text {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"full_text" type: typeType code: 'anot'];
    return constantObj;
}

+ (SEConstant *)function_key {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"function_key" type: typeType code: 'epsk'];
    return constantObj;
}

+ (SEConstant *)function_key_modifiers {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"function_key_modifiers" type: typeType code: 'epsy'];
    return constantObj;
}

+ (SEConstant *)group {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"group" type: typeType code: 'sgrp'];
    return constantObj;
}

+ (SEConstant *)grow_area {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"grow_area" type: typeType code: 'grow'];
    return constantObj;
}

+ (SEConstant *)has_scripting_terminology {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"has_scripting_terminology" type: typeType code: 'hscr'];
    return constantObj;
}

+ (SEConstant *)help_ {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"help_" type: typeType code: 'help'];
    return constantObj;
}

+ (SEConstant *)hidden {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"hidden" type: typeType code: 'hidn'];
    return constantObj;
}

+ (SEConstant *)high_quality {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"high_quality" type: typeType code: 'hqua'];
    return constantObj;
}

+ (SEConstant *)highlight_color {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"highlight_color" type: typeType code: 'hico'];
    return constantObj;
}

+ (SEConstant *)home_directory {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"home_directory" type: typeType code: 'home'];
    return constantObj;
}

+ (SEConstant *)home_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"home_folder" type: typeType code: 'cusr'];
    return constantObj;
}

+ (SEConstant *)href {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"href" type: typeType code: 'href'];
    return constantObj;
}

+ (SEConstant *)id {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"id" type: typeType code: 'ID  '];
    return constantObj;
}

+ (SEConstant *)ignore_privileges {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"ignore_privileges" type: typeType code: 'igpr'];
    return constantObj;
}

+ (SEConstant *)image {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"image" type: typeType code: 'imaA'];
    return constantObj;
}

+ (SEConstant *)incrementor {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"incrementor" type: typeType code: 'incr'];
    return constantObj;
}

+ (SEConstant *)index {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"index" type: typeType code: 'pidx'];
    return constantObj;
}

+ (SEConstant *)insertion_action {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"insertion_action" type: typeType code: 'dhat'];
    return constantObj;
}

+ (SEConstant *)insertion_preference {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"insertion_preference" type: typeType code: 'dhip'];
    return constantObj;
}

+ (SEConstant *)interface {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"interface" type: typeType code: 'intf'];
    return constantObj;
}

+ (SEConstant *)item {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"item" type: typeType code: 'cobj'];
    return constantObj;
}

+ (SEConstant *)key_modifiers {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"key_modifiers" type: typeType code: 'spky'];
    return constantObj;
}

+ (SEConstant *)kind {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"kind" type: typeType code: 'kind'];
    return constantObj;
}

+ (SEConstant *)launcher_items_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"launcher_items_folder" type: typeType code: 'laun'];
    return constantObj;
}

+ (SEConstant *)library_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"library_folder" type: typeType code: 'dlib'];
    return constantObj;
}

+ (SEConstant *)list {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"list" type: typeType code: 'list'];
    return constantObj;
}

+ (SEConstant *)local_domain {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"local_domain" type: typeType code: 'fldl'];
    return constantObj;
}

+ (SEConstant *)local_domain_object {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"local_domain_object" type: typeType code: 'doml'];
    return constantObj;
}

+ (SEConstant *)local_volume {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"local_volume" type: typeType code: 'isrv'];
    return constantObj;
}

+ (SEConstant *)location {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"location" type: typeType code: 'loca'];
    return constantObj;
}

+ (SEConstant *)log_out_when_inactive {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"log_out_when_inactive" type: typeType code: 'aclk'];
    return constantObj;
}

+ (SEConstant *)log_out_when_inactive_interval {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"log_out_when_inactive_interval" type: typeType code: 'acto'];
    return constantObj;
}

+ (SEConstant *)login_item {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"login_item" type: typeType code: 'logi'];
    return constantObj;
}

+ (SEConstant *)looping {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"looping" type: typeType code: 'loop'];
    return constantObj;
}

+ (SEConstant *)magnification {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"magnification" type: typeType code: 'dmag'];
    return constantObj;
}

+ (SEConstant *)magnification_size {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"magnification_size" type: typeType code: 'dmsz'];
    return constantObj;
}

+ (SEConstant *)maximum_value {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"maximum_value" type: typeType code: 'maxV'];
    return constantObj;
}

+ (SEConstant *)menu {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"menu" type: typeType code: 'menE'];
    return constantObj;
}

+ (SEConstant *)menu_bar {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"menu_bar" type: typeType code: 'mbar'];
    return constantObj;
}

+ (SEConstant *)menu_bar_item {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"menu_bar_item" type: typeType code: 'mbri'];
    return constantObj;
}

+ (SEConstant *)menu_button {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"menu_button" type: typeType code: 'menB'];
    return constantObj;
}

+ (SEConstant *)menu_item {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"menu_item" type: typeType code: 'menI'];
    return constantObj;
}

+ (SEConstant *)miniaturizable {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"miniaturizable" type: typeType code: 'ismn'];
    return constantObj;
}

+ (SEConstant *)miniaturized {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"miniaturized" type: typeType code: 'pmnd'];
    return constantObj;
}

+ (SEConstant *)minimize_effect {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"minimize_effect" type: typeType code: 'deff'];
    return constantObj;
}

+ (SEConstant *)minimum_value {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"minimum_value" type: typeType code: 'minW'];
    return constantObj;
}

+ (SEConstant *)modal {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"modal" type: typeType code: 'pmod'];
    return constantObj;
}

+ (SEConstant *)modification_date {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"modification_date" type: typeType code: 'asmo'];
    return constantObj;
}

+ (SEConstant *)modification_time {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"modification_time" type: typeType code: 'mdtm'];
    return constantObj;
}

+ (SEConstant *)modified {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"modified" type: typeType code: 'imod'];
    return constantObj;
}

+ (SEConstant *)modifiers {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"modifiers" type: typeType code: 'epso'];
    return constantObj;
}

+ (SEConstant *)mouse_button {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"mouse_button" type: typeType code: 'epsb'];
    return constantObj;
}

+ (SEConstant *)mouse_button_modifiers {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"mouse_button_modifiers" type: typeType code: 'epsm'];
    return constantObj;
}

+ (SEConstant *)movie_data {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"movie_data" type: typeType code: 'movd'];
    return constantObj;
}

+ (SEConstant *)movie_file {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"movie_file" type: typeType code: 'movf'];
    return constantObj;
}

+ (SEConstant *)movies_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"movies_folder" type: typeType code: 'mdoc'];
    return constantObj;
}

+ (SEConstant *)mtu {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"mtu" type: typeType code: 'mtu '];
    return constantObj;
}

+ (SEConstant *)music_CD {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"music_CD" type: typeType code: 'dhmc'];
    return constantObj;
}

+ (SEConstant *)music_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"music_folder" type: typeType code: '%doc'];
    return constantObj;
}

+ (SEConstant *)name {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"name" type: typeType code: 'pnam'];
    return constantObj;
}

+ (SEConstant *)name_extension {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"name_extension" type: typeType code: 'extn'];
    return constantObj;
}

+ (SEConstant *)natural_dimensions {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"natural_dimensions" type: typeType code: 'ndim'];
    return constantObj;
}

+ (SEConstant *)network_domain {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"network_domain" type: typeType code: 'fldn'];
    return constantObj;
}

+ (SEConstant *)network_domain_object {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"network_domain_object" type: typeType code: 'domn'];
    return constantObj;
}

+ (SEConstant *)network_preferences {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"network_preferences" type: typeType code: 'netp'];
    return constantObj;
}

+ (SEConstant *)network_preferences_object {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"network_preferences_object" type: typeType code: 'neto'];
    return constantObj;
}

+ (SEConstant *)numbers_key_modifiers {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"numbers_key_modifiers" type: typeType code: 'spnm'];
    return constantObj;
}

+ (SEConstant *)orientation {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"orientation" type: typeType code: 'orie'];
    return constantObj;
}

+ (SEConstant *)outline {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"outline" type: typeType code: 'outl'];
    return constantObj;
}

+ (SEConstant *)package_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"package_folder" type: typeType code: 'pkgf'];
    return constantObj;
}

+ (SEConstant *)pages_across {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"pages_across" type: typeType code: 'lwla'];
    return constantObj;
}

+ (SEConstant *)pages_down {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"pages_down" type: typeType code: 'lwld'];
    return constantObj;
}

+ (SEConstant *)paragraph {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"paragraph" type: typeType code: 'cpar'];
    return constantObj;
}

+ (SEConstant *)partition_space_used {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"partition_space_used" type: typeType code: 'pusd'];
    return constantObj;
}

+ (SEConstant *)path {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"path" type: typeType code: 'ppth'];
    return constantObj;
}

+ (SEConstant *)physical_size {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"physical_size" type: typeType code: 'phys'];
    return constantObj;
}

+ (SEConstant *)picture {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"picture" type: typeType code: 'picP'];
    return constantObj;
}

+ (SEConstant *)picture_CD {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"picture_CD" type: typeType code: 'dhpc'];
    return constantObj;
}

+ (SEConstant *)picture_path {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"picture_path" type: typeType code: 'picp'];
    return constantObj;
}

+ (SEConstant *)picture_rotation {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"picture_rotation" type: typeType code: 'chnG'];
    return constantObj;
}

+ (SEConstant *)pictures_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"pictures_folder" type: typeType code: 'pdoc'];
    return constantObj;
}

+ (SEConstant *)pop_up_button {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"pop_up_button" type: typeType code: 'popB'];
    return constantObj;
}

+ (SEConstant *)position {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"position" type: typeType code: 'posn'];
    return constantObj;
}

+ (SEConstant *)preferences_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"preferences_folder" type: typeType code: 'pref'];
    return constantObj;
}

+ (SEConstant *)preferred_rate {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"preferred_rate" type: typeType code: 'prfr'];
    return constantObj;
}

+ (SEConstant *)preferred_volume {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"preferred_volume" type: typeType code: 'prfv'];
    return constantObj;
}

+ (SEConstant *)presentation_mode {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"presentation_mode" type: typeType code: 'prmd'];
    return constantObj;
}

+ (SEConstant *)presentation_size {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"presentation_size" type: typeType code: 'prsz'];
    return constantObj;
}

+ (SEConstant *)preview_duration {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"preview_duration" type: typeType code: 'pvwd'];
    return constantObj;
}

+ (SEConstant *)preview_time {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"preview_time" type: typeType code: 'pvwt'];
    return constantObj;
}

+ (SEConstant *)print_settings {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"print_settings" type: typeType code: 'pset'];
    return constantObj;
}

+ (SEConstant *)process {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"process" type: typeType code: 'prcs'];
    return constantObj;
}

+ (SEConstant *)product_version {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"product_version" type: typeType code: 'ver2'];
    return constantObj;
}

+ (SEConstant *)progress_indicator {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"progress_indicator" type: typeType code: 'proI'];
    return constantObj;
}

+ (SEConstant *)properties {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"properties" type: typeType code: 'pALL'];
    return constantObj;
}

+ (SEConstant *)property_list_file {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"property_list_file" type: typeType code: 'plif'];
    return constantObj;
}

+ (SEConstant *)property_list_item {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"property_list_item" type: typeType code: 'plii'];
    return constantObj;
}

+ (SEConstant *)public_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"public_folder" type: typeType code: 'pubb'];
    return constantObj;
}

+ (SEConstant *)quit_delay {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"quit_delay" type: typeType code: 'qdel'];
    return constantObj;
}

+ (SEConstant *)radio_button {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"radio_button" type: typeType code: 'radB'];
    return constantObj;
}

+ (SEConstant *)radio_group {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"radio_group" type: typeType code: 'rgrp'];
    return constantObj;
}

+ (SEConstant *)random_order {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"random_order" type: typeType code: 'ranD'];
    return constantObj;
}

+ (SEConstant *)recent_applications_limit {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"recent_applications_limit" type: typeType code: 'rapl'];
    return constantObj;
}

+ (SEConstant *)recent_documents_limit {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"recent_documents_limit" type: typeType code: 'rdcl'];
    return constantObj;
}

+ (SEConstant *)recent_servers_limit {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"recent_servers_limit" type: typeType code: 'rsvl'];
    return constantObj;
}

+ (SEConstant *)relevance_indicator {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"relevance_indicator" type: typeType code: 'reli'];
    return constantObj;
}

+ (SEConstant *)requested_print_time {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"requested_print_time" type: typeType code: 'lwqt'];
    return constantObj;
}

+ (SEConstant *)require_password_to_unlock {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"require_password_to_unlock" type: typeType code: 'pwul'];
    return constantObj;
}

+ (SEConstant *)require_password_to_wake {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"require_password_to_wake" type: typeType code: 'pwwk'];
    return constantObj;
}

+ (SEConstant *)resizable {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"resizable" type: typeType code: 'prsz'];
    return constantObj;
}

+ (SEConstant *)role {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"role" type: typeType code: 'role'];
    return constantObj;
}

+ (SEConstant *)row {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"row" type: typeType code: 'crow'];
    return constantObj;
}

+ (SEConstant *)screen_corner {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"screen_corner" type: typeType code: 'epsc'];
    return constantObj;
}

+ (SEConstant *)script {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"script" type: typeType code: 'scpt'];
    return constantObj;
}

+ (SEConstant *)script_menu_enabled {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"script_menu_enabled" type: typeType code: 'scmn'];
    return constantObj;
}

+ (SEConstant *)scripting_additions_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"scripting_additions_folder" type: typeType code: '$scr'];
    return constantObj;
}

+ (SEConstant *)scripts_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"scripts_folder" type: typeType code: 'scr$'];
    return constantObj;
}

+ (SEConstant *)scroll_area {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"scroll_area" type: typeType code: 'scra'];
    return constantObj;
}

+ (SEConstant *)scroll_arrow_placement {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"scroll_arrow_placement" type: typeType code: 'sclp'];
    return constantObj;
}

+ (SEConstant *)scroll_bar {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"scroll_bar" type: typeType code: 'scrb'];
    return constantObj;
}

+ (SEConstant *)scroll_bar_action {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"scroll_bar_action" type: typeType code: 'sclb'];
    return constantObj;
}

+ (SEConstant *)secure_virtual_memory {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"secure_virtual_memory" type: typeType code: 'scvm'];
    return constantObj;
}

+ (SEConstant *)security_preferences {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"security_preferences" type: typeType code: 'secp'];
    return constantObj;
}

+ (SEConstant *)security_preferences_object {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"security_preferences_object" type: typeType code: 'seco'];
    return constantObj;
}

+ (SEConstant *)selected {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"selected" type: typeType code: 'selE'];
    return constantObj;
}

+ (SEConstant *)server {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"server" type: typeType code: 'srvr'];
    return constantObj;
}

+ (SEConstant *)service {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"service" type: typeType code: 'svce'];
    return constantObj;
}

+ (SEConstant *)settable {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"settable" type: typeType code: 'stbl'];
    return constantObj;
}

+ (SEConstant *)shared_documents_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"shared_documents_folder" type: typeType code: 'sdat'];
    return constantObj;
}

+ (SEConstant *)sheet {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"sheet" type: typeType code: 'sheE'];
    return constantObj;
}

+ (SEConstant *)short_name {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"short_name" type: typeType code: 'cfbn'];
    return constantObj;
}

+ (SEConstant *)short_version {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"short_version" type: typeType code: 'assv'];
    return constantObj;
}

+ (SEConstant *)shortcut {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"shortcut" type: typeType code: 'epst'];
    return constantObj;
}

+ (SEConstant *)show_desktop_shortcut {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"show_desktop_shortcut" type: typeType code: 'epde'];
    return constantObj;
}

+ (SEConstant *)show_spaces_shortcut {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"show_spaces_shortcut" type: typeType code: 'spcs'];
    return constantObj;
}

+ (SEConstant *)shutdown_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"shutdown_folder" type: typeType code: 'shdf'];
    return constantObj;
}

+ (SEConstant *)sites_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"sites_folder" type: typeType code: 'site'];
    return constantObj;
}

+ (SEConstant *)size {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"size" type: typeType code: 'ptsz'];
    return constantObj;
}

+ (SEConstant *)slider {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"slider" type: typeType code: 'sliI'];
    return constantObj;
}

+ (SEConstant *)smooth_scrolling {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"smooth_scrolling" type: typeType code: 'scls'];
    return constantObj;
}

+ (SEConstant *)spaces_columns {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"spaces_columns" type: typeType code: 'spcl'];
    return constantObj;
}

+ (SEConstant *)spaces_enabled {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"spaces_enabled" type: typeType code: 'spen'];
    return constantObj;
}

+ (SEConstant *)spaces_preferences {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"spaces_preferences" type: typeType code: 'essp'];
    return constantObj;
}

+ (SEConstant *)spaces_preferences_object {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"spaces_preferences_object" type: typeType code: 'spsp'];
    return constantObj;
}

+ (SEConstant *)spaces_rows {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"spaces_rows" type: typeType code: 'sprw'];
    return constantObj;
}

+ (SEConstant *)spaces_shortcut {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"spaces_shortcut" type: typeType code: 'spst'];
    return constantObj;
}

+ (SEConstant *)speakable_items_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"speakable_items_folder" type: typeType code: 'spki'];
    return constantObj;
}

+ (SEConstant *)speed {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"speed" type: typeType code: 'sped'];
    return constantObj;
}

+ (SEConstant *)splitter {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"splitter" type: typeType code: 'splr'];
    return constantObj;
}

+ (SEConstant *)splitter_group {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"splitter_group" type: typeType code: 'splg'];
    return constantObj;
}

+ (SEConstant *)start_time {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"start_time" type: typeType code: 'offs'];
    return constantObj;
}

+ (SEConstant *)starting_page {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"starting_page" type: typeType code: 'lwfp'];
    return constantObj;
}

+ (SEConstant *)startup {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"startup" type: typeType code: 'istd'];
    return constantObj;
}

+ (SEConstant *)startup_disk {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"startup_disk" type: typeType code: 'sdsk'];
    return constantObj;
}

+ (SEConstant *)startup_items_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"startup_items_folder" type: typeType code: 'empz'];
    return constantObj;
}

+ (SEConstant *)static_text {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"static_text" type: typeType code: 'sttx'];
    return constantObj;
}

+ (SEConstant *)stationery {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"stationery" type: typeType code: 'pspd'];
    return constantObj;
}

+ (SEConstant *)stored_stream {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"stored_stream" type: typeType code: 'isss'];
    return constantObj;
}

+ (SEConstant *)subrole {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"subrole" type: typeType code: 'sbrl'];
    return constantObj;
}

+ (SEConstant *)system_domain {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"system_domain" type: typeType code: 'flds'];
    return constantObj;
}

+ (SEConstant *)system_domain_object {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"system_domain_object" type: typeType code: 'doms'];
    return constantObj;
}

+ (SEConstant *)system_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"system_folder" type: typeType code: 'macs'];
    return constantObj;
}

+ (SEConstant *)tab_group {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"tab_group" type: typeType code: 'tabg'];
    return constantObj;
}

+ (SEConstant *)table {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"table" type: typeType code: 'tabB'];
    return constantObj;
}

+ (SEConstant *)target_printer {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"target_printer" type: typeType code: 'trpr'];
    return constantObj;
}

+ (SEConstant *)temporary_items_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"temporary_items_folder" type: typeType code: 'temp'];
    return constantObj;
}

+ (SEConstant *)text {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"text" type: typeType code: 'ctxt'];
    return constantObj;
}

+ (SEConstant *)text_area {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"text_area" type: typeType code: 'txta'];
    return constantObj;
}

+ (SEConstant *)text_field {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"text_field" type: typeType code: 'txtf'];
    return constantObj;
}

+ (SEConstant *)time_scale {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"time_scale" type: typeType code: 'tmsc'];
    return constantObj;
}

+ (SEConstant *)title {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"title" type: typeType code: 'titl'];
    return constantObj;
}

+ (SEConstant *)titled {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"titled" type: typeType code: 'ptit'];
    return constantObj;
}

+ (SEConstant *)tool_bar {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"tool_bar" type: typeType code: 'tbar'];
    return constantObj;
}

+ (SEConstant *)top_left_screen_corner {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"top_left_screen_corner" type: typeType code: 'eptl'];
    return constantObj;
}

+ (SEConstant *)top_right_screen_corner {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"top_right_screen_corner" type: typeType code: 'eptr'];
    return constantObj;
}

+ (SEConstant *)total_partition_size {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"total_partition_size" type: typeType code: 'appt'];
    return constantObj;
}

+ (SEConstant *)track {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"track" type: typeType code: 'trak'];
    return constantObj;
}

+ (SEConstant *)trash {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"trash" type: typeType code: 'trsh'];
    return constantObj;
}

+ (SEConstant *)type {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"type" type: typeType code: 'ptyp'];
    return constantObj;
}

+ (SEConstant *)type_class {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"type_class" type: typeType code: 'type'];
    return constantObj;
}

+ (SEConstant *)type_identifier {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"type_identifier" type: typeType code: 'utid'];
    return constantObj;
}

+ (SEConstant *)unix_id {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"unix_id" type: typeType code: 'idux'];
    return constantObj;
}

+ (SEConstant *)user {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"user" type: typeType code: 'uacc'];
    return constantObj;
}

+ (SEConstant *)user_domain {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"user_domain" type: typeType code: 'fldu'];
    return constantObj;
}

+ (SEConstant *)user_domain_object {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"user_domain_object" type: typeType code: 'domu'];
    return constantObj;
}

+ (SEConstant *)utilities_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"utilities_folder" type: typeType code: 'uti$'];
    return constantObj;
}

+ (SEConstant *)value {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"value" type: typeType code: 'valL'];
    return constantObj;
}

+ (SEConstant *)value_indicator {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"value_indicator" type: typeType code: 'vali'];
    return constantObj;
}

+ (SEConstant *)version {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"version" type: typeType code: 'vers'];
    return constantObj;
}

+ (SEConstant *)video_DVD {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"video_DVD" type: typeType code: 'dhvd'];
    return constantObj;
}

+ (SEConstant *)video_depth {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"video_depth" type: typeType code: 'vcdp'];
    return constantObj;
}

+ (SEConstant *)visible {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"visible" type: typeType code: 'pvis'];
    return constantObj;
}

+ (SEConstant *)visual_characteristic {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"visual_characteristic" type: typeType code: 'visu'];
    return constantObj;
}

+ (SEConstant *)volume {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"volume" type: typeType code: 'volu'];
    return constantObj;
}

+ (SEConstant *)window {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"window" type: typeType code: 'cwin'];
    return constantObj;
}

+ (SEConstant *)word {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"word" type: typeType code: 'cwor'];
    return constantObj;
}

+ (SEConstant *)workflows_folder {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"workflows_folder" type: typeType code: 'flow'];
    return constantObj;
}

+ (SEConstant *)zone {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"zone" type: typeType code: 'zone'];
    return constantObj;
}

+ (SEConstant *)zoomable {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"zoomable" type: typeType code: 'iszm'];
    return constantObj;
}

+ (SEConstant *)zoomed {
    static SEConstant *constantObj;
    if (!constantObj)
        constantObj = [SEConstant constantWithName: @"zoomed" type: typeType code: 'pzum'];
    return constantObj;
}

@end


