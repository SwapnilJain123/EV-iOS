//
//  AppConstants.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 22/04/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
import UIKit


let KEY_USER = "saved_user"
let KEY_AUTH_TOKEN = "auth_token"


struct AppConstants{
    static let SkillLevels = ["GT1","E1","E2","E3","E4","COACHES"]
    static let TrackYesSkillLevels = ["E1","E2","E3"]
    static let TrackNoSkillLevels = ["GT1"]
    static let emergencyRelationShips = ["Friend","Parent", "Local Guardian", "Other"]
    static let ImageTag = "data:image/png;base64,"
    
    static let KEY_APP_MODE = "appMode"
    static let KEY_DEVICE_TOKEN_STATUS = "key.device.token.status"
    
    static let LOGOUT_TIMEOUT = 1.5
    
    static let DEVICE_TOKEN = "UserDeviceToken"
    
    static let APP_MODE_SWITCH_ENABLED = false
    static let DASHBOARD_SWITCH_ENABLED = true
    
    
    static let APP_TERMS_CONDITIONS = """
<div class=\"inner\">                      <div class=\"agree-one agree-sec\">                <h5><strong>1. RELEASE and WAIVER of LIABILITY, ASSUMPTION of RISK and INDEMNITY AGREEMENT</strong></h5>                        <p>IN CONSIDERATION of being permitted to compete, officiate, observe, work, or participate in any way in the                  EVENT($) or being permitted to enter for any purpose any RESTRICTED AREA (defined as any area requiring                  special authorization, credentials, or permission to enter or any area to which admission by the general                  public is restricted prohibited),EACH OF THE UNDERSIGNED, for himself,his personal representatives,heirs,and                  next of kin:</p>                        <ol>                          <li>Acknowledges, agrees, and represents that he has or will immediately upon entering any of such RESTRICTED                    AREAS, and will continuously thereafter,inspect the RESTRICTED AREAS which he enters,and he further agrees                    and warrants that,if atany time,he is in or about RESTRICTED AREAS and he feels anything to be unsafe, he                    will immediately advise the officials of such and if necessary will leave the RESTRICTED AREAS and/or refuse                    to participate further in the EVENT()S.</li>                          <li>HEREBY RELEASES, WAIVES, DISCHARGES AND COVENANTS NOT TO SUE the promoters, participants, racing                    associations, sanctioning organizations or any subdivision thereof, track operators, track owners,                    officials, competition vehicle owners, drivers, pit crews, rescue personnel, any persons in any RESTRICTED                    AREA, promoters, sponsors, advertisers, owners and leasees of premises used to conduct the EVENTS(S),                    premises and event inspectors, surveyors, underwriters, consultants and others who give recommendations,                    directions, or instructions or engage in risk evaluation or loss control activities regarding the premises                    or EVENT(S) and each of them, their directors, officers, agents and employees, all for the purposes herein                    referred to as· Releasees,\"FROM ALL LIABILITY TO THE UNDERSIGNED, his personal representatives,assigns,                    heirs,and next of kin FOR ANY AND ALL LOSS OR DAMAGE, AND ANY CLAIM OR DEMAND THEREFORE ON ACCOUNT OF INJURY                    TO THE PERSON OR PROPERTY OR RESULTING IN DEATH OF THE UNDERSIGNED ARISING OUT OF OR RELATED TO THE                    EVENT($), WHETHER CAUSED BY THE NEGLIGENCE OF THE RELEASES OR OTHERWISE.</li>                          <li>HEREBY AGREES TO INDEMNIFY AND SAVE AND HOLD HARMLESS the Releasees and each of them FROM ANY LOSS,                    LIABILITY, DAMAGE, OR COST they may incur arising out of or related to the UNDERSIGNED 'S INJURY OR DEATH,                    WHETHER CAUSED BY THENEGLIGENCE OFTHE RELEASEES OR OTHERWISE.</li>                          <li>HEREBY ASSUMES FULL RESPONSIBILITY FOR ANY RISK OF BODILY INJURY, DEATH OR PROPERTY DAMAGE arising out of                    or related to the EVENT(S) whether caused by the NEGLIGENCE OF RELEASEES or otherwise.</li>                          <li>HEREBY acknowledges thatTHE ACTIVITIES OF THE EVENT(S) ARE VERY DANGEROUS and involve the risk of serious                    injury and/or death and/or property damage. Each ofTHE UNDERSIGNED, also expressly acknowledges that                    INJURIES RECEIVED MAY BE COMPOUNDED OR INCREASED BY NEGLIGENT RESCUE OPERATIONS OR PROCEDURES OFTHE                    RELEASES.</li>                          <li>HEREBY agrees that this Release and Waiver of Liability, Assumption of Risk and Indemnity Agreement                    extends to all acts of negligence by the Releasees, INCLUDING NEGLIGENT RESCUE OPERATIONS and intended to be                    as broad and inclusive as is permitted by the laws of the State or Province in which the Event(s) is/are                    conducted and that if any portion thereof is held invalid, it is agreed that the balance shall,                    notwithstanding,continue in full legal force and effect.</li>                        </ol>                        <p><strong>I HAVE READ THIS RELEASE AND WAIVER OF LIABILITY, ASSUMPTION OF RISK, AND INDEMNITY AGREEMENT,                    UNDERSTAND rrs TERMS, UNDERSTAND <br />                    THAT I HAVE GIVEN UP SUBSTANTIAL RIGHTS BY SIGNING rr,AND HAVE SIGNED IT FREELY AND VOLUNTARILY WITHOUT ANY                    INDUCEMENT, ASSURANCE OR GUARANTEE BEING MADETOME AND INTEND MYSIGNATURE TO BE A COMPLETE AND UNCONDITIONAL                    RELEASE OF ALL LIABILITY THE GREATEST EXTENT ALLOWED BY LAW.</strong></p>                              </div>    <hr/>                      <div class=\"agree-two agree-sec\">                        <h5><strong>2. PARENTAL CONSENT, RELEASE and WAIVER of LIABILITY, ASSUMPTION of RISK, and INDEMNITY                    AGREEMENT</strong></h5>                        <span>DESCRIPTION AND LOCATION OF EVENT(S)</span>                <p>IN CONSIDERATION of my minor child (“the Minor\") being permitted to participate in any way in the EVENT(S)                  and/or being permitted to enter for any purpose any RESTRICTED AREA(S) (defined to be any area which requires                  special authorization, credentials, or permission to enter or any area to which admission by the general                  public is restricted or prohibited), I agree:</p>                        <ol>                          <li>I know the nature of the EVENT(S) and the Minor's experience and capabilities, and believe the Minor to be                    qualified to participate in the Event(s). I will inspect the premises, facilities, and equipment to be used,                    or with which the Minor may come in contact. IF I OR THE MINOR BELIEVE ANYTHING IS UNSAFE, I WILL INSTRUCT                    THE MINOR TO IMMEDIATELY LEAVE THE RESTRICTED AREA AND REFUSE TO PARTICIPATE FURTHER IN THE EVENT(S).</li>                          <li>I FULLY UNDERSTAND and will instruct the Minor that: (a) THE ACTIVITIES OF THE EVENT(S) ARE VERY DANGEROUS                    and participation in the Event(s) and/or entry into Restricted Areas involves RISKS AND DANGERS OF SERIOUS                    BODILY INJURY, INCLUDING PERMANENT DISABILITY,PARALYSIS AND DEATH (\"RISKS\"); (b) these Risks and dangers may                    be caused by the Minor's own actions, or inactions, the actions or inactions of others participating in the                    Event(s), the rules of the Event(s), the condition and layout of the premises and equipment, and/or THE                    NEGLIGENCE OF THE \"RELEASEES\" NAMED BELOW; (c) there may be OTHER RISKS NOT KNOWN TO ME or that are not                    readily foreseeable at this time;(d) THE SOCIAL AND ECONOMIC LOSSES and/ or damages that could result from                    those Risk(s) COULD BE SEVERE AND COULD PERMANENTLY CHANGE THE MINOR'S FUTURE.</li>                          <li>I consent to the Minor's participation in the Event(s) and/or entry into restricted areas and HEREBY                    ACCEPT AND ASSUME ALL SUCH RISKS, KNOWN AND UNKNOWN, AND ASSUME ALL RESPONSIBILITY FOR THE LOSSES, COSTS                    ANO/OR DAMAGES FOLLOWING SUCH INJURY, DISABILITY, PARALYSIS OR DEATH, EVEN IF CAUSED, INWHOLE OR IN PART, BY                    THE NEGLIGENCE OF THE\"RELEASEES\" <b>NAMED</b> BELOW.</li>                          <li>I HEREBY RELEASE, DISCHARGE AND COVENANT NOT TO SUE the promoters, participants, racing associations,                    sanctioning organizations or any subdivision thereof, track operators, track owners, officials, car owners,                    drivers, pit crews, rescue personnel, any persons in any Restricted Areas, sponsors, advertisers, owners and                    lessees of premises used to conduct the Event(s), premises or event inspectors, surveyors, underwriters,                    consultants and other persons or entities who give recommendations, directions, or instructions or engage in                    risk evaluation or loss control activities regarding the premises or Event(s) and each of them, their                    directors, officers, agents, employees, representatives, owners ,members, affiliates, successors and                    assigns, all for the purposes herein referred to as “Releasees” FROM ALL LIABILITY TO ME,THE MINOR, my and                    the Minor's personal representatives, assigns, heirs, and next of kin, FOR ANY AND ALL CLAIMS, DEMANDS,                    LOSSES, OR DAMAGES ON ACCOUNT OF ANY INJURY TO ME OR THE MINOR, including, but not limited to, death or                    damage to property, CAUSED OR ALLEGED TO BE CAUSED, IN WHOLE OR IN PART, BY THE NEGLIGENCE OF THE                    \"RELEASEES\" OR OTHERWISE.</li>                          <li>If, despite this release, I, the Minor, or anyone on the Minor's behalf, makes a claim against any of the                    \"Releasees\" named above, I AGREE TO DEFEND, INDEMNIFY AND SAVE AND HOLD HARMLESS THE RELEASEES and each of                    them from ANY LITIGATION EXPENSES, ATTORNEY FEES, LOSS, LIABILITY, DAMAGE, OR COST THEY MAY INCUR DUE TO THE                    CLAIM MADE AGAINST ANY OF THE \"RELEASEES\" NAMED ABOVE, WHETHER THE CLAIM IS BASED ON THE NEGLIGENCE OF THE                    RELEASE OR OTHERWISE.</li>                          <li>I sign this agreement on my own behalf and on behalf of the Minor.</li>                        </ol>                        <p><strong>I HAVE READ THIS PARENTAL CONSENT, RELEASE AND WAIVER LIABILITY, ASSUMPTION OF RISK, AND INDEMNITY                    AGREEMENT UNDERSTAND THAT BY SIGNING IT I GIVE UP SUBSTANTIAL RIGHTS AND/OR THE MINOR WOULD OTHERWISE HAVE                    TO RECOVER DAMAGES FOR LOSSES OCCASIONED BY THE RELEASEE'S FAULT , AND SIGN IT VOLUNTARILY AND WITHOUT                    INDUCEMENT.</strong></p>                                    </div>    <hr/>                      <div class=\"agree-three agree-sec\">                        <h5><strong>3. MINORS ASSUMPTION of RISK and RELEASE and WAIVER OF LIABILITY</strong></h5>                        <p>I have obtained my parent's consent to participate in the above event(s). I understand that I am assuming all                  of the risks if I get hurt during the event(s), and I state the following:</p>                        <ol>                          <li>Both of my parents and I believe that I am qualified to participate in the event(s). I will inspect the                    premises and equipment and if, at any time,I feel anything to be unsafe, I will immediately leave and refuse                    to participate further in the event(s).</li>                          <li>I understand that the ACTIVITIES OF THE EVENT ARE VERY DANGEROUS and INVOLVE RISKS AND DANGERS OF MY BEING                    SERIOUSLY INJURED OR HURT, MY BEING PARALYZED OR KILLED.</li>                          <li>I know that these risks and dangers may be caused by my own actions or inactions, the actions or inactions                    of others participating in the event(s), the rules of the event(s), the condition and layout of the premises                    and equipment, and/or the <b>NEGLIGENCE</b> of others including those persons responsible for conducting the                    event(s).</li>                          <li>I HEREBY ASSUME ALL SUCH RISKS, EVEN IF THE RISKS ARE CREATED BY THE <b>NEGLIGENCE</b> of the promoters,                    participants, racing associations, sanctioning organizations,or any of its subdivisions, track operators,                    track owners,officials, car owners,drivers,pit crews, rescue personnel, any persons in any restricted areas,                    promoters, sponsors, advertisers, owners, and lessees of premises used to conduct the event(s), premises or                    event inspectors, surveyors, underwriters, consultants, and any other person or entity who gives                    recommendations,directions, or instructions, or engages in risk evaluation, loss control activities or sales                    regarding the premises or event(s), and each of them, their directors, officers, agents, employees,                    representatives,owners, members, affiliates, successors, and assigns, all for the purposes herein referred                    to as\"Releasees\".</li>                          <li>I HEREBY RELEASE, WAIVE, COVENANT NOT TO SUE, AND DISCHARGE, ALLOFTHERELEASEES FROM ALL LIABILITY TOME, my                    personal representatives,assign, heirs, and next of kin, for anyandall loss or damage and any claim or any                    demand on account of any injury to me including, but not limited to, my death, whether caused by the                    <b>NEGLIGENCE</b> of the Releasees or otherwise.</li>                        </ol>                        <p><strong>I HAVE READ THE ABOVE ASSUMPTION OF RISK AND RELEASE AND WAIVER OF LIABILITY, UNDERSTAND WHAT I HAVE                    READ, AND SIGN IT VOLUNTARILY</strong><br/><strong>I hereby sign releases as participant, guardian, minor or parent thereof and completely understand                    all risks involved</strong>                  <p>                                                  </div>    <hr/>                      <div class=\"agree-four agree-sec last\">                        <h5><strong>4. Waiver and Release of Liability By Participants</strong></h5>                        <p>I understand that in connection with responding to the COVID-19 pandemic Evolve GT LLC has rented track, or                  tracks and facilities associated with the event. The waiver, release and other representations and covenants                  set forth herein are given in consideration for the provider and facility of event (s) permitting me and/or my                  child or ward to become a guest of the event, or events and occupy the space at the event</p>                        <ol>                  <li><u>Acceptance of Risk; Release; Indemnification</u>. I am fully aware that there are a number of risks                    associated                    with me and/or my child or ward entering on the event property, becoming a guest / participant and/or                    occupying at the event / track during the COVID-19 pandemic or related to the circumstances of the event,                    including without limitation: (a) I and/or my child or ward or our visitors could contract COVID-19 or other                    diseases such as the flu or legionnaires disease which could result in a serious medical condition requiring                    medical treatment in a hospital or could possibly lead to death; and (b) I and/or my child or ward or our                    visitors will be subject to normal risks associated with staying at the track such as physical injuries or                    even death or loss or damage to personal property, including without limitation, from slips or falls, food                    poisoning or allergic reaction to food served, physical or verbal altercations with staff, employees, or                    other guests, terrorist or other violence, theft or vandalism, accidents, or fires or other disasters                    affecting the event. On behalf of myself and/or my child or ward and our heirs, successors and assigns, I                    knowingly and freely, assume all such risks, both known and unknown, relating to my and/or my child’s or                    ward’s occupancy of a hotel room and being a guest at the event as described above, and I hereby forever                    release, waive, relinquish, and discharge the provider and track, along with their officers, directors,                    managers, officials, trustees, agents, employees, or other representatives, and their successors and assigns                    (collectively, the <i><b>“Event provider and track facility”</b></i>), from any and all claims, demands, liabilities,                    rights, damages, expenses, and causes of action of whatever kind or nature, and other losses of any kind,                    whether known or unknown, foreseen or unforeseen, (collectively, <i><b>“Damages”</b></i>) as a result of me and/or my                    child or ward being a guest at the Event and occupying a space at the event as described above, including                    but not limited to those related to the above described personal Injuries, death, disease or property                    losses, or any other loss, and including but not limited to claims based on the alleged negligence of any                    provider or provider Representative or any other person. I further promise not to sue Evolve GT LLC or the                    track or Representative, and agree to indemnify and hold them harmless from any and all Damages resulting                    from my and/or my child’s or ward’s being a guest or occupying any area at the track day events.</li>                </ol>                        <p><strong>READ CAREFULLY -- BY SIGNING THIS DOCUMENT YOU MAY GIVE UP IMPORTANT LEGAL RIGHTS.</strong></p>                      </div>                    </div>
"""
    
    
    static let TERMS_OF_USE = """
<h3>Terms and Conditions</h3>
<p>By accessing this mobile application, you are agreeing to be bound by these Mobile Application Terms and Conditions of Use, all applicable laws and regulations, and agree that you are responsible for compliance with any applicable local laws. If you do not agree with any of these terms, you are prohibited from using or accessing this site. The materials contained in this Mobile Application are protected by applicable copyright and trademark law.</p>
<h3>Use License</h3>
<p>a. Permission is granted to temporarily download one copy of the materials (information or software) on Evolve GT’s Mobile Application for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:</p>
<ol>
<li>Modify or copy the materials;</li>
<li>Use the materials for any commercial purpose, or for any public display (commercial or non-commercial);</li>
<li>Attempt to recompile or reverse engineer any software contained on Evolve GT’s Mobile Application;</li>
<li>Remove any copyright or other proprietary notations from the materials;</li>
<li>Transfer the materials to another person or “mirror” the materials on any other server.</li>
</ol>
<p>b. This license shall automatically terminate if you violate any of these restrictions and may be terminated by Evolve GT at any time. Upon terminating your viewing of these materials or upon the termination of this license, you must destroy any downloaded materials in your possession whether in electronic or printed format.</p>
<h3>Disclaimer</h3>
<p>a. The materials on Evolve GT’s Mobile Application are provided “as is”. Evolve GT makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties, including without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights. Further, Evolve GT does not warrant or make any representations concerning the accuracy, likely results, or reliability of the use of the materials on its Internet Mobile Application or otherwise relating to such materials or on any sites linked to this site.</p>
<h3>Limitations</h3>
<p>In no event shall Evolve GT or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption,) arising out of the use or inability to use the materials on Moto Gladiator’s Internet site, even if Evolve GT or a Evolve GT authorized representative has been notified orally or in writing of the possibility of such damage. Because some jurisdictions do not allow limitations on implied warranties, or limitations of liability for consequential or incidental damages, these limitations may not apply to you.</p>
<h3>Revisions and Errata</h3>
<p>The materials appearing on Evolve GT Mobile Application could include technical, typographical, or photographic errors. Evolve GT does not warrant that any of the materials on its Mobile Application are accurate, complete, or current. Evolve GT may make changes to the materials contained on its Mobile Application at any time without notice. Evolve GT does not, however, make any commitment to update the materials.</p>
<h3>Links</h3>
<p>Evolve GT has not reviewed all of the sites linked to its Internet Mobile Application and is not responsible for the contents of any such linked site. The inclusion of any link does not imply endorsement by Evolve GT of the site. Use of any such linked Mobile Application is at the user’s own risk.</p>
<h3>Application Terms of Use Modifications</h3>
<p>Evolve GT may revise these terms of use for its Mobile Application at any time without notice. By using this Mobile Application you are agreeing to be bound by the then current version of these Terms and Conditions of Use.</p>
<h3>Governing Law</h3>
<p>Any claim relating to Evolve GT’s Mobile Application shall be governed by the laws of the State of Virginia without regard to its conflict of law provisions. General Terms and Conditions applicable to Use of a Mobile Application.</p>
"""
    
    static let REFUND_POLICY = """
<h3>Refund Policy</h3><p>As of June 05, 2019; all purchases are final and we do not offer refunds. <br>You may be eligible for a instore-credit, please send an email to Support@EvolveGT.com and we'll work with you in accordance of Evolve GT's guidelines.</p>
"""
    static let PRIVACY_POLICY = """
<h3>Privacy Policy</h3>
<p>
Your privacy is very important to us. Accordingly, we have developed this Policy in order for you to understand how we collect, use, communicate and disclose and make use of personal information. The following outlines our privacy policy.
<ol>
<li>
 • Before or at the time of collecting personal information, we will identify the purposes for which information is being collected.
</li><li>
 • We will collect and use of personal information solely with the objective of fulfilling those purposes specified by us and for other compatible purposes, unless we obtain the consent of the individual concerned or as required by law.</li><li>
 • We will only retain personal information as long as necessary for the fulfillment of those purposes.</li><li>
 • We will collect personal information by lawful and fair means and, where appropriate, with the knowledge or consent of the individual concerned.</li><li>
 • Personal data should be relevant to the purposes for which it is to be used, and, to the extent necessary for those purposes, should be accurate, complete, and up-to-date.</li><li>
 • We will protect personal information by reasonable security safeguards against loss or theft, as well as unauthorized access, disclosure, copying, use or modification.</li><li>
 • We will make readily available to customers information about our policies and practices relating to the management of personal information.</li>
<p>
We are committed to conducting our business in accordance with these principles in order to ensure that the confidentiality of personal information is protected and maintained.

"""
    
    static let MRLMessage = """
The Motogladiator Race License is an annual (Jan. 1 2013 Dec. 31) membership that allows a rider to race in the Motogladiator race series. \n\n    To Qualify for a Motogladiator Race License, a rider must have raced with another race organization, such as CCS or WERA, within the past 5 years, or, be an Intermediate (E2) or above level rider and have taken a race certification class with an approved organization (i.e., Riders Club, Penguin Road Racing). Riders who complete the EvolveGT Race Certification Training are also eligible to race Motogladiator\n\n    If you have not already raced in the Motogladiator series, when you purchase a Motogladiator Race License you will be prompted to email EvolveGT the supporting documentation. Acceptable documentation includes your training completion certificate or CCS WERA race license (license can be no more than 5 years old). If you do not have documentation, please explanation why you qualify for a race license.\n\n    For questions or additional information, please email us at support@motogladiator.com.\n
"""
}
struct ScreenTitle{
    
    //Mark: Admin Screen
    static let TITLE_EVENTS = "Events"
    static let TITLE_EVENTS_USERS = "Event Participants"
    static let TITLE_SIGNATURE = "Signature"
    
    //Mark: User Screen
    static let TITLE_DASHBOARD = "Dashboard"
    static let TITLE_WAIVER = "E-Waiver"
    static let TITLE_CREATE_ACCOUNT = "Create Your Account"
    
    static let TITLE_UPCOMING_EVENTS = "Upcoming Events"
    static let TITLE_PAST_EVENTS = "Past Events"
    static let TITLE_ALL_EVENTS = "All Events"
    
    static let TITLE_CREDIT_HISTORY = "Credit History"
    static let TITLE_FORGOT_PASSWORD = "Forgot Password"
    static let TITLE_ABOUT_US = "About Us"
    static let TITLE_CHANGE_PASSWORD = "Change Password"
    
    static let TITLE_SHOPS = "Shop"
    static let TITLE_ARCHIE_CARDS = "Archie Cards"
    static let TITLE_GIFT_CARDS = "Gift Cards"
    static let TITLE_CART = "Cart"
    static let TITLE_REVIEW_CART = "Review Cart"
    static let TITLE_CART_PAYMENT = "Payment"
    static let TITLE_PAYMENT_SUCCESS = "Transaction Receipt"
    static let TITLE_MEMBERSHIP = "Membership"
    static let TITLE_PROFILE = "Edit Profile"
    
    static let TITLE_COACH_DUTIES = "Coach Duties"
    static let TITLE_TERMS_N_CONDITIONS = "Terms & Conditions"
    static let TITLE_SETTINGS = "Settings"
    
}

struct ScreenSize{
    
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    
    static let IS_IPHONE_5s = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    
    static let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    
    static let IS_IPHONE_6p = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    
    static let IS_IPHONE_X = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH >= 812.0
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
    
    static let IS_BIG_SCREEN_DEVICE = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH >= 700
    
}
