//
//  SingleInterfaceTableViewController.m
//  QuickNetworkSettings
//
//  Created by Alec Geatches on 5/24/12.
//  Copyright (c) 2012 Alec Geatches. All rights reserved.
//

#import "SingleInterfaceTableViewController.h"

#import "NICInfo.h"
#import "NICInfoSummary.h"

#define NO_INFORMATON_STRING @"none"

@implementation SingleInterfaceTableViewController

@synthesize macLabel;
@synthesize ipv4AddressLabel;
@synthesize ipv4BroadcastLabel;
@synthesize ipv4NetmaskLabel;
@synthesize ipv6AddressLabel;
@synthesize nicInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:nicInfo.interfaceName];

    if([nicInfo.nicIPInfos count] != 0) {
        NICIPInfo *info = (NICIPInfo *)[nicInfo.nicIPInfos objectAtIndex:0];
        [ipv4AddressLabel setText:info.ip];
        [ipv4NetmaskLabel setText:info.netmask];
        [ipv4BroadcastLabel setText:info.broadcastIP];
    } else {
        [ipv4AddressLabel setText:NO_INFORMATON_STRING];
        [ipv4NetmaskLabel setText:NO_INFORMATON_STRING];
        [ipv4BroadcastLabel setText:NO_INFORMATON_STRING];
    }
    
    if([nicInfo.nicIPv6Infos count] != 0) {
        NICIPInfo *info = (NICIPInfo *)[nicInfo.nicIPv6Infos objectAtIndex:0];
        [ipv6AddressLabel setText:info.ip];
    } else {
        [ipv6AddressLabel setText:NO_INFORMATON_STRING];
    }
    
    [macLabel setText:[[nicInfo macAddressWithSeparator:@":"] lowercaseString]];
}

- (void)viewDidUnload {
    [self setMacLabel:nil];
    [self setIpv4AddressLabel:nil];
    [self setIpv4BroadcastLabel:nil];
    [self setIpv4NetmaskLabel:nil];
    [self setIpv6AddressLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

-(void)tableView:(UITableView*)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath*)indexPath withSender:(id)sender {
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    NSString *copyText = nil;
    
    if(indexPath.section == 0) {
        copyText = [macLabel text];
    } else if(indexPath.section == 1) {
        NSArray *ipv4Labels = [NSArray arrayWithObjects:ipv4AddressLabel, ipv4BroadcastLabel, ipv4NetmaskLabel, nil];
        
        copyText = [(UILabel *)[ipv4Labels objectAtIndex:indexPath.row] text];
    } else if(indexPath.section) {
        copyText = [ipv6AddressLabel text];
    }
    
    if (copyText) {
        [pasteBoard setString:copyText];
    }
}

-(BOOL)tableView:(UITableView*)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath*)indexPath withSender:(id)sender {
    if(action == @selector(copy:)) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
