;;; Compiled snippets and support files for `c++-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'c++-mode
		     '(("wxmain" "#include <wx/help.h>\n\n// main.hpp\n#ifndef _MAIN_H_\n#define _MAIN_H_\n\n#include <wx/wx.h>             // wxApp\n\nclass wxHelpControllerBase;\nclass MainFrame;\n\n// Define a new application type, each program should derive a class from wxApp\nclass MyApp : public wxApp\n{\npublic:\n    // Override base class virtuals:\n    // wxApp::OnInit() is called on application startup and is a good place\n    // for the app initialization (doing it here and not in the ctor\n    // allows to have an error return: if OnInit() returns false, the\n    // application terminates)\n    virtual bool OnInit();\n\n    // called before OnInit() and before any window is created\n    bool OnPreInit();\n    void OnAfterInit();\n    virtual int OnExit();\n    ~MyApp();\n\npublic:\n    MainFrame* frame;\n    wxHelpControllerBase *m_helpController;\n};\n\nDECLARE_APP(MyApp)\n#endif\n\n\n// main_frame.hpp\n#ifndef _MAIN_FRAME_H\n#define _MAIN_FRAME_H\n\n#include <wx/wx.h>\n\nclass MainFrame;\n\nclass MainFrame:public wxFrame\n{\npublic:\n    MainFrame();\n    ~MainFrame();\n    void InitGUI();\nprivate:\n    void OnExit(wxCommandEvent&);\n    void OnHelpContents(wxCommandEvent&);\n    wxMenuBar* CreateMenubar();\nprivate:\n    DECLARE_EVENT_TABLE()\n    wxMenuBar *_menubar;\n    wxSizer *_sz;\n};\n#endif\n\n// main_frame.cpp\n#define APP_NAME \"${1:MyKillApp}\"\n\n#include <wx/textctrl.h>\n#include <wx/stattext.h>\n#include <wx/button.h>\n\n//#include \"main_frame.hpp\"\n\n//-------------------------------\n// class MainFrame\n//-------------------------------\nBEGIN_EVENT_TABLE(MainFrame, wxFrame)\n    EVT_MENU(wxID_EXIT,MainFrame::OnExit)\n    EVT_MENU(wxID_HELP_CONTENTS,MainFrame::OnHelpContents)\nEND_EVENT_TABLE()\n\n//--------------------------------------------------\n// Public method\n//--------------------------------------------------\nMainFrame::MainFrame():wxFrame(0,wxID_ANY,wxEmptyString),_sz(0)\n{\n\n    _sz=new wxBoxSizer(wxVERTICAL);\n    _menubar=new wxMenuBar();\n\n    wxMenu* fMenu=new wxMenu();\n    fMenu->Append(wxID_EXIT, _(\"E&xit\"));\n    _menubar->Append(fMenu,_(\"&File\"));\n\n    wxMenu *vMenu=new wxMenu();\n    vMenu->Append(wxID_VIEW_LIST, _(\"My &Gallery\"));\n    _menubar->Append(vMenu,_(\"&View\"));\n\n    wxMenu* hMenu=new wxMenu();\n    hMenu->Append(wxID_ANY, wxString::Format(_(\"&About %s...\"),_(APP_NAME)));\n    hMenu->Append(wxID_HELP_CONTENTS, _(\"&Contents\"));\n    _menubar->Append(hMenu,_(\"&Help\"));\n    $0\n    SetMenuBar(_menubar);\n\n    Layout();\n    return;\n}\n\nMainFrame::~MainFrame()\n{\n}\n\nvoid MainFrame::OnExit(wxCommandEvent& WXUNUSED(event))\n{\n    Close();\n    return;\n}\n\nvoid MainFrame::OnHelpContents(wxCommandEvent& WXUNUSED(event))\n{\n    return;\n}\n\n//main.cpp\n// Create a new application object: this macro will allow wxWidgets to create\n// the application object during program execution (it's better than using a\n// static object for many reasons) and also declares the accessor function\n// wxGetApp() which will return the reference of the right type (i.e. the_app and\n// not wxApp).\nIMPLEMENT_APP(MyApp)\n\nbool MyApp::OnPreInit()\n{\n  return true;\n}\n\nbool MyApp::OnInit()\n{\n  if(!OnPreInit()){ return false; }\n\n  // call the base class initialization method, currently it only parses a\n  // few common command-line options but it could be do more in the future\n  if ( !wxApp::OnInit() )\n      return false;\n\n\n#ifdef __WXMSW__\n  m_helpController = new wxCHMHelpController();\n  //see /Users/cb/wxWidgets-2.9.4/samples/help/doc/\n  //m_helpController->Initialize(CAppConfig::Get()->GetHelpFileName().GetFullPath());\n#else\n  m_helpController = new wxHelpController;\n#endif\n\n  /**\n  * code from src/common/msgout.cpp\n  * wxMessageOutput* wxMessageOutput::Set(wxMessageOutput* msgout)\n  * {\n  *    wxMessageOutput* old = ms_msgOut;\n  *    ms_msgOut = msgout;\n  *    return old;\n  * }\n  */\n\n  delete wxMessageOutput::Set(new wxMessageOutputDebug());\n\n\n  //before create any GUI, let's check if we use skin?\n\n  //OnAfterInit();\n  //frame will be released automatically in DeletePendingObjects()\n  frame=new MainFrame();\n\n  //set the shape again\n  SetTopWindow(frame);\n  frame->Center();\n\n  // Show the frame as it's created initially hidden.\n  frame->Show(true);\n  //frame->Maximize();\n\n#ifndef NDEBUG\n  wxRect rc=frame->GetRect();\n#endif\n\n  SetTopWindow(frame);\n  // Return true to tell program to continue (false would terminate).\n  return true;\n}\n\nvoid MyApp::OnAfterInit()\n{\n  return;\n}\n\nint MyApp::OnExit()\n{\n#ifdef __WXMSW__\n  m_helpController->Quit();\n  delete m_helpController;\n#endif\n\n  return(wxApp::OnExit());\n}\n\nMyApp::~MyApp()\n{\n}\n\n// Local Variables:\n// c-basic-offset: 2\n// indent-tabs-mode: nil\n// End:\n//\n// vim: et sts=2 sw=2\n" "wxmain" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/wxmain" nil nil)
		       ("lo" "wxLogDebug(_T(\"${1:object}=%${2:s}\"),${1:$(yas/substr yas-text \"[^ ]*\")});\n" "wxLogDebug(object)" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/wxlogobject.yasnippet" nil nil)
		       ("wl" "wxLogDebug(_T(\"${1:hello}\"));" "wxLogDebug" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/wxlog.yasnippet" nil nil)
		       ("lo" "wxLogError(_T(\"${1:object}=%${2:s}\"),${1:$(yas/substr yas-text \"[^ ]*\")});\n" "wxLogError(object)" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/wxerrobject.yasnippet" nil nil)
		       ("wtctrl" "wxTextCtrl(this,${1:wxID_ANY})\n" "wxTextCtrl" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/wtctrl" nil nil)
		       ("wstxt" "wxStaticText(this,${1:wxID_ANY},_(\"${2:Default}\"))\n" "wxStaticText" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/wstxt" nil nil)
		       ("wsep" "wxFileName::GetPathSeparator()" "wxFileName::GetPathSeparator" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/wsep" nil nil)
		       ("wevthdl" "void ${1:MethodName}(${2:wxCommandEvent}&);\n$0\nvoid ${3:ClassName}::${1:$(yas/substr yas-text \"[^ ]*\")}(${2:$(yas/substr yas-text \"[^ ]*\")}& WXUNUSED(event)) {\n    return;\n}\n" "wxEventHandler" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/wevthdl" nil nil)
		       ("wbtn" "wxButton(this,${1:wxID_ANY},_(\"${2:&OK}\"))\n" "wxButton" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/wbtn" nil nil)
		       ("wa" "wxASSERT(${1:0});$0\n" "wxASSERT(...)" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/wassert" nil nil)
		       ("vec" "std::vector<${1:Class}> ${2:var}${3:(${4:10}, $1($5))};" "vector" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/vector" nil nil)
		       ("tryw" "try {\n    `(or yas/selected-text (car kill-ring))`\n} catch ${1:Exception} {\n\n}\n" "tryw" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/tryw" nil nil)
		       ("try" "try {\n    $0\n} catch (${1:type}) {\n\n}\n" "try" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/try" nil nil)
		       ("throw" "throw ${1:MyError}($0);" "throw" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/throw" nil nil)
		       ("th" "this" "this" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/this" nil nil)
		       ("ts" "BOOST_AUTO_TEST_SUITE( ${1:test_suite1} )\n\n$0\n\nBOOST_AUTO_TEST_SUITE_END()" "test_suite" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/test_suite" nil nil)
		       ("test_main" "int main(int argc, char **argv) {\n      ::testing::InitGoogleTest(&argc, argv);\n       return RUN_ALL_TESTS();\n}" "test_main" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/test_main" nil nil)
		       ("tc" "BOOST_AUTO_TEST_CASE( ${1:test_case} )\n{\n        $0\n}" "test case" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/test case" nil nil)
		       ("str" "#include <string>" "str" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/str" nil nil)
		       ("std" "using namespace std;" "std" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/std" nil nil)
		       ("pb" "public:\n        $0" "public" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/public" nil nil)
		       ("pt" "protected:\n        $0" "protected" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/protected" nil nil)
		       ("pr" "private:\n        $0" "private" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/private" nil nil)
		       ("pack" "void cNetCommBuffer::pack(${1:type}) {\n\n}\n\n$0" "pack" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/pack" nil nil)
		       ("os" "#include <ostream>" "ostream" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/ostream" nil nil)
		       ("+" "${1:MyClass} $1::operator+(const $1 &other)\n{\n    $1 result = *this;\n    result += other;\n    return result;\n}" "operator+" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/operator_plus" nil nil)
		       ("!=" "bool ${1:MyClass}::operator!=(const $1 &other) const {\n    return !(*this == other);\n}" "operator!=" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/operator_neq" nil nil)
		       ("<<" "std::ostream& operator<<(std::ostream& s, const ${1:type}& ${2:c})\n{\n         $0\n         return s;\n}" "operator<<" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/operator_less" nil nil)
		       ("+=" "${1:MyClass}& $1::operator+=(${2:const $1 &rhs})\n{\n  $0\n  return *this;\n}" "operator+=" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/operator_increment" nil nil)
		       (">>" "istream& operator>>(istream& s, const ${1:type}& ${2:c})\n{\n         $0\n}\n" "operator>>" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/operator_great" nil nil)
		       ("==" "bool ${1:MyClass}::operator==(const $1 &other) const {\n     $0\n}" "operator==" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/operator_equal" nil nil)
		       ("[]" "${1:Type}& operator[](${2:int index})\n{\n        $0\n}" "operator[]" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/operator_brackets" nil nil)
		       ("=" "${1:MyClass}& $1::operator=(const $1 &rhs) {\n    // Check for self-assignment!\n    if (this == &rhs)\n      return *this;\n    $0\n    return *this;\n}" "operator=" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/operator_assign" nil nil)
		       ("ns" "namespace ${1:Namespace} {\n          \n          `yas/selected-text`\n\n}" "namespace" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/namespace" nil nil)
		       ("mod" "class ${1:Class} : public cSimpleModule\n{\n   $0\n}" "module" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/module" nil nil)
		       ("map" "std::map<${1:type1}$0> ${2:var};" "map" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/map" nil nil)
		       ("iter" "${1:std::}${2:vector<int>}::iterator ${3:iter};\n" "iterator" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/iterator" nil nil)
		       ("io" "#include <iostream>" "io" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/io" nil nil)
		       ("il" "inline $0" "inline" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/inline" nil nil)
		       ("ignore" "${1:std::}cin.ignore(std::numeric_limits<std::streamsize>::max(), '\\n');" "ignore" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/ignore" nil nil)
		       ("gtest" "#include <gtest/gtest.h>" "gtest" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/gtest" nil nil)
		       ("f" "${1:void} ${2:Class}::${3:name}(${4:args})${5: const}\n{\n        $0\n}\n" "function" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/function" nil nil)
		       ("f" "${1:type} ${2:name}(${3:args})${4: const};" "fun_declaration" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/fun_declaration" nil nil)
		       ("fr" "friend $0;" "friend" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/friend" nil nil)
		       ("fori" "for (${1:iter}=${2:var}.begin(); $1!=$2.end(); ++$1) {\n    $0\n}" "fori" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/fori" nil nil)
		       ("fixt" "BOOST_FIXTURE_TEST_SUITE( ${1:name}, ${2:Fixture} )\n\n$0\n\nBOOST_AUTO_TEST_SUITE_END()" "fixture" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/fixture" nil nil)
		       ("enum" "enum ${1:NAME}{\n$0\n};" "enum" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/enum" nil nil)
		       ("cast" "check_and_cast<${1:Type} *>(${2:msg});" "dynamic_casting" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/dynamic_casting" nil nil)
		       ("dla" "delete[] ${1:arr};" "delete[]" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/delete_array" nil nil)
		       ("dl" "delete ${1:pointer};" "delete" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/delete" nil nil)
		       ("<<" "friend std::ostream& operator<<(std::ostream&, const ${1:Class}&);" "d_operator<<" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/d_operator_less" nil nil)
		       ("c[" "const ${1:Type}& operator[](${2:int index}) const;" "d_operator[]_const" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/d_operator_brackets_const" nil nil)
		       ("[" "${1:Type}& operator[](${2:int index});" "d_operator[]" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/d_operator_brackets" nil nil)
		       ("d+=" "${1:MyClass}& operator+=(${2:const $1 &});" "d+=" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/d_increment" nil nil)
		       ("cstd" "#include <cstdlib>" "cstd" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/cstd" nil nil)
		       ("cpp" "#include \"`(file-name-nondirectory (file-name-sans-extension (buffer-file-name)))`.h\"" "cpp" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/cpp" nil nil)
		       ("cout" "std::cout << ${1:string} $0<< std::endl;" "cout" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/cout" nil nil)
		       ("ct" "${1:Class}::$1(${2:args}) ${3: : ${4:init}}\n{\n        $0\n}" "constructor" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/constructor" nil nil)
		       ("c[" "const ${1:Type}& operator[](${2:int index}) const\n{\n        $0\n}" "const_[]" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/const_array" nil nil)
		       ("cin" "cin >> $0;" "cin" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/cin" nil nil)
		       ("err" "cerr << $0;\n" "cerr" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/cerr" nil nil)
		       ("req" "BOOST_REQUIRE( ${1:condition} );\n$0" "boost_require" nil nil nil "d:/HOME/.emacs.d/snippets/c++-mode/boost_require" nil nil)))


;;; Do not edit! File generated at Sun Feb 28 20:40:53 2021
